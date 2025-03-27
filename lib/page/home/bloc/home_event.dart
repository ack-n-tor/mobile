part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable{
  @override
  List<Object?> get props => [];
}

class LoadSettings extends HomeEvent{}

class LoadHomeData extends HomeEvent{}

class OnHomeRefresh extends HomeEvent{}

class OnLocationRefresh extends HomeEvent{
  final User? user;
  final LocationServiceProvider locationProvider;
  OnLocationRefresh({required this.user,required this.locationProvider});
}

class OnSwitchPressed extends HomeEvent{
  final User? user;
  final LocationServiceProvider locationProvider;
  OnSwitchPressed({required this.user,required this.locationProvider});
}

class OnTokenVerification extends HomeEvent{

}

class OnLocationEnabled extends HomeEvent{
  final User user;
  final LocationServiceProvider locationProvider;

  OnLocationEnabled({required this.user,required this.locationProvider});
}

class OnResetEvent extends HomeEvent{

}
