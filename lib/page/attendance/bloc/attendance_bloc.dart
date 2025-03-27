import 'dart:convert';
import 'dart:io';
import 'package:core/core.dart';
import 'package:domain/domain.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:event_bus_plus/res/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location_track/location_track.dart';
import 'package:meta_club_api/meta_club_api.dart';
import 'package:offline_attendance/domain/offline_attendance_repository.dart';
import 'package:onesthrm/page/attendance/attendance.dart';

typedef AttendanceBlocFactory = AttendanceBloc Function({required AttendanceType attendanceType, String? selfie});

class AttendanceBloc extends Bloc<AttendanceEvent, AttendanceState> {
  final SubmitAttendanceUseCase submitAttendanceUseCase;
  final LocationServiceProvider locationServiceProvider;
  final LogoutUseCase logoutUseCase;
  final AttendanceType attendanceType;
  final String? _selfie;
  late bool isCheckedIn;
  late bool isCheckedOut;
  final OfflineAttendanceRepository offlineAttendanceRepo;
  final EventBus eventBus;
  final SubmitRemarksUseCase _submitRemarksUseCase;
  AttendanceBody body = AttendanceBody();

  AttendanceBloc(
      {required this.submitAttendanceUseCase,
      required this.attendanceType,
      required this.eventBus,
      required this.offlineAttendanceRepo,
      required this.locationServiceProvider,
      required this.logoutUseCase,
      required SubmitRemarksUseCase submitRemarksUseCase,
      String? selfie})
      : _selfie = selfie,
        _submitRemarksUseCase = submitRemarksUseCase,
        super(const AttendanceState(status: NetworkStatus.initial)) {
    body.date = DateFormat('yyyy-MM-dd', 'en').format(DateTime.now());

    on<OnLocationInitEvent>(_onLocationInit);
    on<OnLocationRefreshEvent>(_onLocationRefresh);
    on<OnRemoteModeChanged>(_onRemoteModeUpdate);
    on<OnAttendance>(_onAttendance);
    on<OnOfflineAttendance>(_onOfflineAttendance);
    on<OnLocationUpdated>(_onLocationUpdated);
    on<OnRemarkEvent>(_onRemark);

    SharedUtil.getIntValue(shiftId).then((sid) {
      body.shiftId = sid;
    });

    if (attendanceType == AttendanceType.qr ||
        attendanceType == AttendanceType.face ||
        attendanceType == AttendanceType.selfie) {
      ///for auto check in/out , we need to initialize location
      add(OnLocationInitEvent());

      ///----------------------------------------------------///
      ///if not offline attendance, this event call automatically
      add(OnAttendance());

      ///---------------///---------------------------------///
    }
  }

  void _onLocationInit(OnLocationInitEvent event, Emitter<AttendanceState> emit) async {
    isCheckedIn = await offlineAttendanceRepo.isAlreadyInCheckedIn(date: body.date!);
    isCheckedOut = await offlineAttendanceRepo.isAlreadyInCheckedOut(date: body.date!);

    body.latitude = '${locationServiceProvider.userLocation.latitude}';
    body.longitude = '${locationServiceProvider.userLocation.longitude}';

    ///Initialize attendance data at global state
    AttendanceData? attendanceData = event.dashboardModel?.data?.attendanceData;
    globalState.set(inTime, attendanceData?.inTime);
    globalState.set(outTime, attendanceData?.outTime);
    globalState.set(stayTime, attendanceData?.stayTime);

    add(OnLocationRefreshEvent());
  }

  void _onLocationUpdated(OnLocationUpdated event, Emitter<AttendanceState> emit) async {
    emit(state.copyWith(location: event.place, actionStatus: ActionStatus.location));
  }

  void _onLocationRefresh(OnLocationRefreshEvent event, Emitter<AttendanceState> emit) async {
    isCheckedIn = await offlineAttendanceRepo.isAlreadyInCheckedIn(date: body.date!);
    isCheckedOut = await offlineAttendanceRepo.isAlreadyInCheckedOut(date: body.date!);

    emit(state.copyWith(
        locationLoaded: false,
        actionStatus: ActionStatus.refresh,
        isCheckedIn: isCheckedIn,
        isCheckedOut: isCheckedOut));
    locationServiceProvider.placeStream.listen((location) async {
      body.latitude = '${locationServiceProvider.userLocation.latitude}';
      body.longitude = '${locationServiceProvider.userLocation.longitude}';
      add(OnLocationUpdated(place: location));
    });
    await Future.delayed(const Duration(seconds: 1));
    emit(state.copyWith(locationLoaded: true, actionStatus: ActionStatus.refresh));
  }

  void _onRemoteModeUpdate(OnRemoteModeChanged event, Emitter<AttendanceState> emit) {
    body.mode = event.mode;
    SharedUtil.setRemoteModeType(event.mode);
  }

  void _onAttendance(OnAttendance event, Emitter<AttendanceState> emit) async {
    emit(state.copyWith(status: NetworkStatus.loading, actionStatus: ActionStatus.refresh));
    body.mode ??= await SharedUtil.getRemoteModeType() ?? 0;
    body.latitude = '${locationServiceProvider.userLocation.latitude}';
    body.longitude = '${locationServiceProvider.userLocation.longitude}';
    body.attendanceId = globalState.get(attendanceId);
    if (_selfie != null) {
      final imageBase64 = await File(_selfie).readAsBytes();
      body.selfieImage = base64Encode(imageBase64);
    }

    final dataRes = await submitAttendanceUseCase(body: body);

    dataRes.fold((l) {
      if (l.failureType == FailureType.invalidToken) {
        logoutUseCase();
      } else {
        ///----------------------------------*********--------------------------------------------------------
        emit(state.copyWith(
            status: NetworkStatus.failure,
            checkData: CheckData(message: l.meaningfulMessage),
            actionStatus: ActionStatus.checkInOut));

        ///----------------------------------*********--------------------------------------------------------
      }
    }, (data) {
      body.isOffline = false;
      final inTime = getDDMMYYYYAsString(
          date: data?.checkInOut?.checkIn ?? '00:00:00 00:00',
          inputFormat: 'yyyy-mm-dd hh:mm',
          outputFormat: 'hh:mm aa');
      final outTime = getDDMMYYYYAsString(
          date: data?.checkInOut?.checkOut ?? '00:00:00 00:00',
          inputFormat: 'yyyy-mm-dd hh:mm',
          outputFormat: 'hh:mm aa');
      body.attendanceId = data?.checkInOut?.id;
      body.inTime = inTime;
      body.outTime = outTime;
      if (body.inTime != null && body.outTime != null) {
        body.attendanceId = null;
        globalState.set(attendanceId, null);
        offlineAttendanceRepo.clearCheckData();
      } else {
        globalState.set(attendanceId, data?.checkInOut?.checkOut == null ? data?.checkInOut?.id : null);
      }
      globalState.set(inTime, data?.checkInOut?.inTime);
      globalState.set(outTime, data?.checkInOut?.outTime);
      globalState.set(stayTime, data?.checkInOut?.stayTime);

      ///------------------------Refresh data in OfflineAttendanceCubit-------------------------------------
      eventBus.fire(OnOnlineAttendanceUpdateEvent(body: body));

      ///----------------------------------*********--------------------------------------------------------
      emit(state.copyWith(status: NetworkStatus.success, checkData: data, actionStatus: ActionStatus.checkInOut));
    });
  }

  void _onRemark(OnRemarkEvent event, Emitter<AttendanceState> emit) async {
    _submitRemarksUseCase(body: event.body);
    Navigator.pop(event.context);
  }

  void _onOfflineAttendance(OnOfflineAttendance event, Emitter<AttendanceState> emit) async {
    emit(state.copyWith(status: NetworkStatus.loading, actionStatus: ActionStatus.checkInOut));

    body.isOffline = true;
    body.mode ??= await SharedUtil.getRemoteModeType() ?? 0;
    body.attendanceId = globalState.get(attendanceId);
    body.latitude = '${locationServiceProvider.userLocation.latitude}';
    body.longitude = '${locationServiceProvider.userLocation.longitude}';
    if (_selfie != null) {
      final imageBase64 = await File(_selfie).readAsBytes();
      body.selfieImage = base64Encode(imageBase64);
    }

    ///----------------------------------*********--------------------------------------------------------
    isCheckedIn = await offlineAttendanceRepo.isAlreadyInCheckedIn(date: body.date!);
    isCheckedOut = await offlineAttendanceRepo.isAlreadyInCheckedOut(date: body.date!);

    if (body.attendanceId != null) {
      add(OnAttendance());
    } else {
      ///------------------------Refresh data in OfflineAttendanceCubit-------------------------------------
      eventBus.fire(OnOfflineAttendanceUpdateEvent(body: body));

      ///----------------------------------*********--------------------------------------------------------
      final checkData = CheckData(
          message:
              '${(isCheckedIn == isCheckedOut || isCheckedIn == false) ? 'Check-In' : 'Check-Out'} successfully. CHEERS!!!',
          result: true,
          checkInOut: convertToCheckout(body: body, inStatus: isCheckedIn ? 'check-in' : 'check-out'));

      emit(state.copyWith(status: NetworkStatus.success, checkData: checkData));
    }
  }

  CheckInOut convertToCheckout({required AttendanceBody body, String? inStatus}) {
    final checkData = CheckInOut(
        id: 0,
        remoteMode: body.mode,
        date: body.date,
        inTime: body.inTime,
        outTime: body.outTime,
        latitude: body.latitude,
        longitude: body.longitude,
        inStatus: inStatus);
    return checkData;
  }
}
