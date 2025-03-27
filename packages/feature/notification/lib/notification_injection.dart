import 'package:core/core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:notification/notification.dart';
import 'package:notification/src/data/services/local_notification_service.dart';
import 'package:notification/src/data/services/notification_database_factory.dart';
import 'package:notification/src/data/services/notification_manager_impl.dart';
import 'package:notification/src/data/services/notification_repository_database.dart';
import 'package:notification/src/domain/usecases/add_notification_usecase.dart';
import 'package:notification/src/domain/usecases/clean_notifications_usecase.dart';
import 'package:notification/src/domain/usecases/get_notification_token_usecase.dart';
import 'package:notification/src/domain/usecases/initialize_notification_usecase.dart';
import 'package:notification/src/presentation/cubits/add_notification_cubit.dart';
import 'package:notification/src/presentation/cubits/notification_list_cubit.dart';

class NotificationInjection {
  Future<void> initInjection() async {
    instance.registerSingleton<FirebaseMessaging>(FirebaseMessaging.instance, signalsReady: true);
    instance.registerSingleton<LocalNotificationService>(LocalNotificationService(), signalsReady: true);
    instance.registerSingleton<NotificationDatabaseFactory>(NotificationDatabaseFactory(), signalsReady: true);
    instance.registerSingleton<NotificationRepositoryDatabase>(
        NotificationRepositoryDatabase(databaseFactory: instance()),
        signalsReady: true);
    instance.registerSingleton<NotificationManager>(
        NotificationManagerImpl(notificationRepositoryDatabase: instance(), firebaseMessaging: instance()),
        signalsReady: true);
    instance.registerSingleton<InitializeNotificationUseCase>(
        InitializeNotificationUseCase(notificationManager: instance()),
        signalsReady: true);
    instance.registerFactory<CleanNotificationUseCase>(() => CleanNotificationUseCase(notificationManager: instance()));
    instance.registerFactory<AddNotificationUseCase>(() => AddNotificationUseCase(notificationManager: instance()));
    instance.registerFactory<ReadNotificationUseCase>(() => ReadNotificationUseCase(hrmCoreBaseService: instance()));
    instance.registerFactory<AddEditNotificationCubitFactory>(
        () => () => AddEditNotificationCubit(notificationManager: instance(), readNotificationUseCase: instance()));
    instance.registerSingleton<NotificationsScreenFactory>(
        () => NotificationCenterScreen(notificationCubitFactory: instance(), addEditNotificationCubitFactory: instance()),
        signalsReady: true);
    instance.registerSingleton<GetNotificationTokenUseCase>(
        GetNotificationTokenUseCase(notificationManager: instance()),
        signalsReady: true);
    instance.registerSingleton<NotificationAppStartedHandlerService>(
        NotificationAppStartedHandlerService(
            localNotificationService: instance(),
            addNotificationUseCase: instance(),
            initializeNotificationUseCase: instance(),
            notificationTokenUseCase: instance()),
        signalsReady: true);
    instance.registerSingleton<NotificationFromServerUseCase>(
        NotificationFromServerUseCase(hrmCoreBaseService: instance()),
        signalsReady: true);
    instance.registerSingleton<NotificationListCubitFactory>(
        () => NotificationListCubit(
            notificationManager: instance(),
            notificationFromServerUseCase: instance(),
            addNotificationUseCase: instance()),
        signalsReady: true);
  }
}
