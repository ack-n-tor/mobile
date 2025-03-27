import 'package:core/core.dart';
import 'package:onesthrm/page/daily_report/bloc/daily_report_bloc/daily_report_bloc.dart';

class ReportAppInjection {
  Future<void> initInjection() async {
    instance.registerFactory<DailyReportBlocFactory>(
        () => () => DailyReportBloc(loadDailyReportUseCase: instance(), submitDailyReportUseCase: instance()));
  }
}
