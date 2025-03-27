import 'package:bloc/bloc.dart';
import 'package:notification/src/data/database_entities/notification_db_entity.dart';
import 'package:notification/src/domain/services/notification_manager.dart';
import 'package:notification/src/domain/usecases/read_notification_usecase.dart';
import 'add_notification_state.dart';

typedef AddEditNotificationCubitFactory = AddEditNotificationCubit Function();

class AddEditNotificationCubit extends Cubit<AddEditNotificationState> {
  final NotificationManager notificationManager;
  final ReadNotificationUseCase readNotificationUseCase;

  AddEditNotificationCubit({required this.notificationManager, required this.readNotificationUseCase})
      : super(const AddEditNotificationState());

  void onNotificationUpdated({required NotificationDbEntity notification}) {
    ///update seen status when notification not seen
    if (!notification.seen) {
      ///update seen status on remote server
      readNotificationUseCase(id: notification.id);
    }

    ///update seen status on local database
    notificationManager.updateNotification(notificationId: notification.key, seen: true);
  }

  void onNotificationAdded({required NotificationDbEntity notification}) {
    notificationManager.createNotification(
        id: notification.id,
        title: notification.title,
        description: notification.description,
        payload: '',
        date: notification.date,
        seen: notification.seen);
  }
}
