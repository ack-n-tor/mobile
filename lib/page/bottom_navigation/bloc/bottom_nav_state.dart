part of 'bottom_nav_cubit.dart';

enum BottomNavTab { home, leave, menu, attendance, notification }

class BottomNavState extends Equatable {
const BottomNavState({
this.tab = BottomNavTab.home,
});

final BottomNavTab tab;

@override
List<Object> get props => [tab];
}