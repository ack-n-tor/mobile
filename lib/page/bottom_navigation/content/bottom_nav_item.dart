import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:onesthrm/page/bottom_navigation/bloc/bottom_nav_cubit.dart';

class BottomNavItem extends StatelessWidget {
  final String icon;
  final bool isSelected;
  final BottomNavTab tab;

  const BottomNavItem(
      {super.key,
      required this.icon,
      required this.isSelected,
      required this.tab});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: SvgPicture.asset(
        icon,
        height: 20.h,
        // color: isSelected ? colorPrimary : const Color(0xFF555555),
        colorFilter: ColorFilter.mode(isSelected ? Branding.colors.primaryDark : const Color(0xFF555555), BlendMode.srcIn) ,
      ),
      onPressed: () => context.read<BottomNavCubit>().setTab(tab),
    );
  }
}
