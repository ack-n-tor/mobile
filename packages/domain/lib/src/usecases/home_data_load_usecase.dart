import 'package:core/core.dart';
import 'package:fpdart/src/either.dart';
import 'package:meta_club_api/meta_club_api.dart';

class HomeDatLoadUseCase extends BaseUseCase<DashboardModel?>{
  final HRMCoreBaseService hrmCoreBaseService;

  HomeDatLoadUseCase({required this.hrmCoreBaseService});

  @override
  Future<Either<Failure, DashboardModel?>> call() async {
    return await hrmCoreBaseService.getDashboardData();
  }
}
