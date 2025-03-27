import 'package:core/core.dart';
import 'package:custom_timer/custom_timer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onesthrm/page/attendance/content/animated_circular_button.dart';
import 'package:onesthrm/page/attendance/tab_content/tab_animated_circular_button.dart';
import 'package:onesthrm/page/authentication/bloc/authentication_bloc.dart';
import 'package:onesthrm/page/break/bloc/break_bloc.dart';
import 'package:onesthrm/page/break/view/content/break_app_bar.dart';
import 'package:onesthrm/page/break/view/content/break_history_content.dart';
import 'package:onesthrm/page/home/bloc/bloc.dart';
import 'package:onesthrm/page/internet_connectivity/bloc/bloc.dart';
import 'package:onesthrm/page/internet_connectivity/view/device_offline_view.dart';
import 'package:onesthrm/res/dialogs/custom_dialogs.dart';
import 'package:onesthrm/res/nav_utail.dart';

import 'break_header.dart';
import 'break_remarks_content.dart';

class BreakContent extends StatefulWidget {
  final HomeBloc homeBloc;

  const BreakContent({super.key, required this.homeBloc});

  @override
  State<BreakContent> createState() => BreakContentState();
}

class BreakContentState extends State<BreakContent> with TickerProviderStateMixin, WidgetsBindingObserver {
  late AnimationController controller;
  late CustomTimerController controllerBreakTimer;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);

    controller = AnimationController(vsync: this, duration: const Duration(seconds: 2));

    controllerBreakTimer = CustomTimerController(
        vsync: this,
        begin: Duration(
            hours: int.parse(globalState.get(hour) ?? '0'),
            minutes: int.parse(globalState.get(min) ?? '0'),
            seconds: int.parse(globalState.get(sec) ?? '0')),
        end: const Duration(days: 1));

    if (globalState.get(isBreak)) {
      controllerBreakTimer.start();
    } else {
      ///current time of milliseconds
      SharedUtil.deleteKey(breakTime);
      controllerBreakTimer.reset();
    }
  }

  @override
  void dispose() {
    controllerBreakTimer.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        if (kDebugMode) {
          print("resumed");
        }
        if (globalState.get(isBreak) == true) {
          controllerBreakTimer.start();
        } else {
          controllerBreakTimer.reset();
        }
        break;
      case AppLifecycleState.inactive:
        if (kDebugMode) {
          print("inactive");
        }
        break;
      case AppLifecycleState.paused:
        if (kDebugMode) {
          print("paused");
        }
        break;
      case AppLifecycleState.detached:
        if (kDebugMode) {
          print("detached");
        }
        break;
      case AppLifecycleState.hidden:
        if (kDebugMode) {
          print("hidden");
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<AuthenticationBloc>().state.data;
    final dashboard = widget.homeBloc.state.dashboardModel;
    final internetStatus = context.read<InternetBloc>().state.status;

    return DeviceOfflineView(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(0.0),
          child: AppBar(
            automaticallyImplyLeading: false,
          ),
        ),
        body: BlocListener<BreakBloc, BreakState>(
          listenWhen: (oldState, newState) => oldState.isTimerStart != newState.isTimerStart,
          listener: (context, state) {
            if (globalState.get(isBreak) == true) {
              controllerBreakTimer.start();

              ///current time of milliseconds
              SharedUtil.setValue(breakTime, '${DateTime.now().millisecondsSinceEpoch}');
            } else {
              controllerBreakTimer.reset();

              ///current time of milliseconds
              SharedUtil.deleteKey(breakTime);
            }

            ///show message from apis weather break/back
            ///success or failure
            if (state.breakBack?.message != null) {
              showLoginDialog(
                  context: context,
                  message: '${user?.user?.name}',
                  body: '${state.breakBack?.message}',
                  isSuccess: state.status == NetworkStatus.success && state.breakBack?.result == true);
            }

            ///if break / back success then home api call again
            ///for update break status in parent widget
            if (state.status == NetworkStatus.success) {
              widget.homeBloc.add(LoadHomeData());
            }

            if (globalState.get(isBreak) == false &&
                state.status == NetworkStatus.success &&
                state.breakBack?.data?.isRemark == true) {
              Navigator.pop(context);

              NavUtil.navigateScreen(
                  context,
                  BlocProvider.value(
                    value: context.read<BreakBloc>(),
                    child: BreakRemarksContent(
                      breakId: state.breakBack?.data?.id ?? 0,
                      breakType: state.breakBack?.data?.breakTypeName ?? '',
                    ),
                  ));
            }
          },
          child: BlocBuilder<BreakBloc, BreakState>(builder: (context, state) {

            if (dashboard != null && state.breaks.isEmpty) {
              context
                  .read<BreakBloc>()
                  .add(OnInitialHistoryEvent(breaks: dashboard.data!.breakHistory?.breakHistory?.todayHistory));
            }

            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  BreakAppBar(
                    title: "break_time".tr(),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  BreakHeader(timerController: controllerBreakTimer, dashboardModel: dashboard),
                  state.status == NetworkStatus.loading
                      ? RectangularCardShimmer(height: 184.h, width: 184.w)
                      : DeviceUtil.isTablet
                          ? TabAnimatedCircularButton(
                              title: globalState.get(isBreak) == true ? 'Back'.tr() : 'Break'.tr(),
                              color: globalState.get(isBreak) == true
                                  ? Branding.colors.primaryDark
                                  : Branding.colors.primaryLight.withOpacity(0.5),
                              onComplete: () {
                                if (internetStatus == InternetStatus.online) {
                                  context.read<BreakBloc>().add(OnBreakBackEvent());
                                }
                              },
                            )
                          : AnimatedCircularButton(
                              title: globalState.get(isBreak) == true ? 'Back'.tr() : 'Break'.tr(),
                              color: globalState.get(isBreak) == true
                                  ? Branding.colors.primaryDark
                                  : Branding.colors.primaryLight.withOpacity(0.5),
                              onComplete: () {
                                if (internetStatus == InternetStatus.online) {
                                  context.read<BreakBloc>().add(OnBreakBackEvent());
                                }
                              },
                            ),
                  BreakHistoryContent()
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}
