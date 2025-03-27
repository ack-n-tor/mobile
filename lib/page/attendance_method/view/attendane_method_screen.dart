import 'package:cached_network_image/cached_network_image.dart';
import 'package:core/core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';
import 'package:meta_club_api/meta_club_api.dart';
import 'package:onesthrm/page/attendance/content/shift_dropdown.dart';
import 'package:onesthrm/page/attendance_method/bloc/attendance_method_bloc.dart';
import 'package:onesthrm/page/attendance_report/view/pluto_attendance_report_page.dart';
import 'package:onesthrm/page/language/bloc/language_bloc.dart';
import '../../attendance_report/view/attendance_report_page.dart';
import '../../authentication/bloc/authentication_bloc.dart';
import '../../home/bloc/home_bloc.dart';

class AttendanceMethodScreen extends StatefulWidget {
  const AttendanceMethodScreen({super.key});

  static final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  static Route route({required HomeBloc homeBloc, AttendanceType attendanceType = AttendanceType.normal}) {
    return MaterialPageRoute(
        builder: (_) => BlocProvider.value(value: homeBloc, child: const AttendanceMethodScreen()));
  }

  @override
  State<AttendanceMethodScreen> createState() => _AttendanceMethodScreenState();
}

class _AttendanceMethodScreenState extends State<AttendanceMethodScreen> with TickerProviderStateMixin {
  late AnimationController animationController;
  ValueNotifier<MultiShift?> selectedShift = ValueNotifier(null);

  void updateShift({required List<MultiShift> shifts}) {
    SharedUtil.getIntValue(shiftId).then((sid) {
      final cachedShift = shifts.firstWhere((e) => e.shiftId == sid);
      selectedShift.value = cachedShift;
    });
  }

  @override
  void initState() {
    animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 2000));
    final settings = context.read<HomeBloc>().state.settings;
    if (settings != null) {
      if (settings.data!.shifts.isNotEmpty) {
        selectedShift.value = settings.data?.shifts.first;
        SharedUtil.getIntValue(shiftId).then((sid) {
          if(settings.data!.shifts.isNotEmpty){
            final cachedShift = settings.data?.shifts.firstWhere((e) => e.shiftId == sid);
            if (cachedShift != null) {
              selectedShift.value = cachedShift;
            }
          }
        });
      }
    }
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.read<HomeBloc>().state.settings;
    final homeData = context.watch<HomeBloc>().state.dashboardModel;
    final loginData = context.read<AuthenticationBloc>().state.data;
    final baseUrl = globalState.get(companyUrl);

    return BlocProvider(
      create: (context) => AttendanceMethodBloc(
        metaClubApiClient: MetaClubApiClient(httpService: instance()),
        homeBloc: context.read<HomeBloc>(),
        loginData: loginData,
        baseUrl: baseUrl,
      ),
      child: Scaffold(
          key: AttendanceMethodScreen._scaffoldKey,
          extendBody: true,
          appBar: AppBar(
            title: Text('attendance_method'.tr(),),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    final name = globalState.get(dashboardStyleId);
                    switch (name) {
                      case 'pluto':
                        Navigator.push(context, PlutoAttendanceReportPage.route(settings: settings!));
                      case 'earth':
                        Navigator.push(context, AttendanceReportPage.route(settings: settings!));
                      case 'neptune':
                        Navigator.push(context, AttendanceReportPage.route(settings: settings!));
                      case 'mars':
                        Navigator.push(context, AttendanceReportPage.route(settings: settings!));
                    default:
                        Navigator.push(context, AttendanceReportPage.route(settings: settings!));
                    }
                  },
                  child: Lottie.asset(
                    'assets/images/ic_report_lottie.json',
                    height: 40.h,
                    width: 40.w,
                  ),
                ),
              ),
            ],
          ),
          body: BlocBuilder<LanguageBloc, LanguageState>(builder: (context, state) {
            return Container(
                height: double.infinity,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Branding.colors.primaryLight, Branding.colors.primaryLight.withOpacity(0.5)])),
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 0.h),
                child: Column(
                  children: [
                    if (settings != null && selectedShift.value != null)
                      ValueListenableBuilder<MultiShift?>(
                        valueListenable: selectedShift,
                        builder: (_, value, __) {
                          return ShiftDropdown(
                            shifts: settings.data?.shifts ?? [],
                            selectedShift: value,
                            onShiftSelected: (shift) {
                              SharedUtil.setIntValue(shiftId, shift?.shiftId);
                              ///update listener for shift changes
                              updateShift(shifts: settings.data?.shifts ?? []);
                            },
                          );
                        },
                      ),
                    if (settings != null && settings.data?.methods != null)
                    Expanded(
                      child: GridView.builder(
                        itemCount: settings.data?.methods.length ?? 0,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 5,
                          mainAxisSpacing: 5,
                          mainAxisExtent: 270, // here set custom Height You Want
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          ///List length
                          int length = homeData?.data?.menus?.length ?? 0;

                          ///Animation instance
                          Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                              parent: animationController,
                              curve: Interval((1 / length) * index, 1.0, curve: Curves.fastOutSlowIn)));
                          animationController.forward();

                          final method = settings.data?.methods[index];

                          return method != null
                              ? InkWell(
                                  onTap: () {
                                    context.read<AttendanceMethodBloc>().add(AttendanceNavEvent(
                                        context: context,
                                        slugName: method.slug,
                                        shiftId: selectedShift.value?.shiftId));
                                  },
                                  child: Card(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(3.0),
                                          child: CachedNetworkImage(
                                            height: 150,
                                            width: double.infinity,
                                            fit: BoxFit.cover,
                                            imageUrl: settings.data?.methods[index].image ?? "",
                                            placeholder: (context, url) => Center(child: Image.asset("assets/images/placeholder_image_one.webp"),),
                                            errorWidget: (context, url, error) => Image.asset("assets/images/placeholder_image_one.webp"),),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Text(
                                            settings.data?.methods[index].title?.tr() ?? "",
                                            maxLines: 1,
                                            style: const TextStyle(
                                              color: Colors.black87, fontSize: 14, fontWeight: FontWeight.bold,),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                                          child: Text(
                                            settings.data?.methods[index].subTitle?.tr() ?? "",
                                            maxLines: 3,
                                            style: const TextStyle(color: Colors.black45, fontSize: 12,),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : const SizedBox.shrink();
                        },
                      ),
                    ),
                  ],
                ));
          })),
    );
  }
}
