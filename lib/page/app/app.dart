import 'package:core/core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:onesthrm/page/app_permission_page/app_permission_page.dart';
import 'package:onesthrm/page/attendance/bloc/offline_attendance_bloc/offline_attendance_qubit.dart';
import 'package:onesthrm/page/belletin/bloc/bulletin_bloc.dart';
import 'package:onesthrm/routes/src/generate_routes.dart';
import '../authentication/bloc/authentication_bloc.dart';
import '../bottom_navigation/view/bottom_navigation_page.dart';
import '../internet_connectivity/bloc/internet_bloc.dart';
import '../language/bloc/language_bloc.dart';
import '../login/view/login_page.dart';
import '../onboarding/bloc/onboarding_bloc.dart';
import '../onboarding/view/onboarding_page.dart';

typedef AppFactory = App Function();

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    final onBoardingBloc = instance<OnboardingBlocFactory>();
    final bulletinBloc = instance<BulletinBlocFactory>();
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => onBoardingBloc()),
        BlocProvider(create: (_) => bulletinBloc()),
        BlocProvider(create: (_) => AuthenticationBloc(authenticationRepository: instance())),
        BlocProvider(create: (_) => InternetBloc()..checkConnectionStatus()),
        BlocProvider(create: (_) => LanguageBloc()),
        BlocProvider(create: (_) => OfflineCubit(offlineAttendanceRepo: instance(), eventBus: instance()))
      ],
      child: const AppView(),
    );
  }
}

class AppView extends StatefulWidget {
  const AppView({super.key});

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {
  NavigatorState get _navigator => instance<GlobalKey<NavigatorState>>().currentState!;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingBloc, OnboardingState>(
      builder: (_, state) {
        return ScreenUtilInit(
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) {

            final generatedRoute = instance<OnGeneratedRoutesFactory>();

            return MaterialApp(
              debugShowCheckedModeBanner: false,
              navigatorKey: instance<GlobalKey<NavigatorState>>(),
              builder: (context, child) {
                return MultiBlocListener(
                  listeners: [
                    BlocListener<AuthenticationBloc, AuthenticationState>(
                      listener: (context, state) {
                        ///update company data at application initial event
                        final company = context.read<OnboardingBloc>().state.selectedCompany;
                        globalState.set(companyName, company?.companyName);
                        globalState.set(companyId, company?.id);
                        globalState.set(companyUrl, company?.url);
                        switch (state.status) {
                          case AuthenticationStatus.authenticated:
                            SharedUtil.getBoolValue(isDisclosure).then((isDisclosure) {
                              if (isDisclosure) {
                                _navigator.pushAndRemoveUntil(BottomNavigationPage.route(), (route) => false);
                              } else {
                                _navigator.pushAndRemoveUntil(
                                  AppPermissionPage.route(),
                                  (route) => false,
                                );
                              }
                            });
                            break;
                          case AuthenticationStatus.unauthenticated:
                            if (context.read<AuthenticationBloc>().state.data != null) {
                              _navigator.pushAndRemoveUntil(BottomNavigationPage.route(), (route) => false);
                            } else {
                              if (company == null) {
                                _navigator.pushAndRemoveUntil(OnboardingPage.route(), (_) => false);
                              } else {
                                _navigator.pushAndRemoveUntil(LoginPage.route(), (route) => false);
                              }
                            }
                            break;
                          default:
                            break;
                        }
                      },
                    ),
                  ],
                  child: child!,
                );
              },
              theme: state.theme ?? initialTheme.copyWith(textTheme: GoogleFonts.poppinsTextTheme()),
              localizationsDelegates: context.localizationDelegates,
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              onGenerateRoute: generatedRoute().onGenerateRoute,
            );
          },
        );
      },
    );
  }
}
