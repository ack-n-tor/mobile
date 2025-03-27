import 'dart:io';

import 'package:core/core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:home_widget/home_widget.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:notification/notification.dart';
import 'package:onesthrm/injection/app_injection.dart';
import 'package:onesthrm/page/app/app.dart';
import 'package:onesthrm/page/app/app_bloc_observer.dart';
import 'package:path_provider/path_provider.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Load environment variables from .env
  await dotenv.load(fileName: ".env");

  /// Initialize localization
  await EasyLocalization.ensureInitialized();

  /// Initialize Firebase with secure config
  await Firebase.initializeApp(
    name: "hodlSaasHrm",
    options: DefaultFirebaseOptions.currentPlatform,
  );

  /// Initialize app-level dependencies
  await initAppModule();

  /// Additional DI layer
  await AppInjection().initInjection();

  /// Notification handling
  await instance<NotificationAppStartedHandlerService>().onAppStarted();

  /// Setup Hydrated Bloc storage
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: await getApplicationDocumentsDirectory(),
  );

  /// Bloc observer for debugging
  Bloc.observer = AppBlocObserver();

  /// Lock orientation
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  /// Launch the app
  runApp(
    EasyLocalization(
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('bn', 'BN'),
        Locale('ar', 'AR'),
      ],
      path: 'assets/translations',
      saveLocale: true,
      fallbackLocale: const Locale('en', 'US'),
      child: instance<AppFactory>()(),
    ),
  );
}

/// Updates home widget with check-in/out state
Future<void> updateAppWidget({required bool isCheckedIn}) async {
  await HomeWidget.saveWidgetData<bool>('isCheckedIn', isCheckedIn);
  await HomeWidget.updateWidget(
    name: 'HomeScreenCheckInOutWidgetProvider',
    iOSName: 'HomeScreenCheckInOutWidgetProvider',
    qualifiedAndroidName:
        'com.example.onesthrm.HomeScreenCheckInOutWidgetProvider', // ← update this too if needed
  );
}

/// Bypass certificate issues (use cautiously in dev)
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
