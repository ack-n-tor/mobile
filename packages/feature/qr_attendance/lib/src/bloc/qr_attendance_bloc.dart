import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:meta_club_api/meta_club_api.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_attendance/src/res/enum.dart';

part 'qr_attendance_event.dart';

part 'qr_attendance_state.dart';

class QRAttendanceBloc extends Bloc<QRAttendanceEvent, QRAttendanceState> {
  final MetaClubApiClient metaClubApiClient;
  final Route callBackRoute;
  final qrViewController = MobileScannerController(
    facing: CameraFacing.back,
    detectionSpeed: DetectionSpeed.normal,
    torchEnabled: false,
  );

  QRAttendanceBloc({required this.metaClubApiClient, required this.callBackRoute})
      : super(const QRAttendanceState(status: NetworkStatus.initial)) {
    on<QRScanData>(_onGetQrScanData);
  }

  FutureOr<void> _onGetQrScanData(QRScanData event, Emitter<QRAttendanceState> emit) async {
    emit(state.copyWith(status: NetworkStatus.loading));
    final data = {'qr_scan': event.qrData};
    await metaClubApiClient.checkQRValidations(data).then((success) {
      success.fold((l) async {
        emit(state.copyWith(status: NetworkStatus.failure, isSuccess: false, onErrorMessage: "Invalid QR code"));
        Fluttertoast.showToast(
            msg: state.onErrorMessage ?? '', toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.TOP);
        await qrViewController.stop();
      }, (isSuccess) {
        if (isSuccess) {
          emit(state.copyWith(status: NetworkStatus.success));
          Navigator.pushReplacement(event.context!, callBackRoute);
        } else {
          emit(
            state.copyWith(
                status: NetworkStatus.failure,
                isSuccess: false,
                onErrorMessage: "The QR code doesn't match, please retry"),
          );
          Fluttertoast.showToast(
              msg: state.onErrorMessage ?? '', toastLength: Toast.LENGTH_LONG, gravity: ToastGravity.TOP);
        }
      });
    });
  }
}
