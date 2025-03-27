import 'package:core/core.dart';
import 'bloc/leave_bloc/leave_bloc.dart';
import 'bloc/leave_details_bloc/leave_details_cubit.dart';

class LeaveInjection {
  Future<void> initInjection() async {
    instance.registerFactory<FactoryLeaveBloc>(() => () => LeaveBloc(
        loadLeaveRequestDataUseCase: instance(),
        loadLeaveRequestTypeUseCase: instance(),
        submitLeaveRequestUseCase: instance(),
        loadLeaveSummeryDataUseCase: instance()));
    instance.registerFactory<LeaveDetailsCubitFactory>(() => ({required int userId, required int requestId}) =>
        LeaveDetailsCubit(
            leaveCancelRequestUseCase: instance(),
            loadLeaveDetailsDataUseCase: instance(),
            userId: userId,
            requestId: requestId));
  }
}
