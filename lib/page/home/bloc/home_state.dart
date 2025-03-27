part of 'home_bloc.dart';

class HomeState extends Equatable {
  final Settings? settings;
  final NetworkStatus status;
  final DashboardModel? dashboardModel;
  final bool isSwitched;

  const HomeState(
      {this.status = NetworkStatus.initial,
      this.settings,
      this.dashboardModel,
      this.isSwitched = true});

  HomeState copy(
      {BuildContext? context,
      Settings? settings,
      DashboardModel? dashboardModel,
      NetworkStatus? status,
      bool? isSwitched}) {
    return HomeState(
        settings: settings ?? this.settings,
        status: status ?? this.status,
        dashboardModel: dashboardModel ?? this.dashboardModel,
        isSwitched: isSwitched ?? this.isSwitched);
  }

  factory HomeState.fromJson(Map<String, dynamic> json,bool isTokenVerified) {
    return HomeState(
        settings: Settings.fromJson(json['settings']),
        status: NetworkStatus.success,
        dashboardModel: DashboardModel.fromJson(json['dashboard']),
        isSwitched: json['isLocation']);
  }

  Map<String, dynamic> toJson() => {
        'settings': {
          "result": true,
          "message": '',
          "data": settings?.data?.toJson()
        },
        'isLocation': isSwitched,
        'dashboard': {
          "result": true,
          "message": '',
          "data": dashboardModel?.data?.toJson()
        },
      };

  @override
  List<Object?> get props => [settings, dashboardModel, status, isSwitched];
}
