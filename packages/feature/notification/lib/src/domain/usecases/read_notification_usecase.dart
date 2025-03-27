import 'package:core/core.dart';
import 'package:fpdart/fpdart.dart';
import 'package:meta_club_api/meta_club_api.dart';

class ReadNotificationUseCase {
  final HRMCoreBaseService hrmCoreBaseService;

  ReadNotificationUseCase({required this.hrmCoreBaseService});

  Future<Either<Failure, bool>> call({required int id}) async {
    return await hrmCoreBaseService.readNotification(id: id);
  }
}
