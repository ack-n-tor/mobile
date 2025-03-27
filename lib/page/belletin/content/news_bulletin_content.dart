import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onesthrm/page/belletin/bloc/bulletin_bloc.dart';
import 'package:onesthrm/page/belletin/bloc/bulletin_state.dart';
import 'marquee.dart';

class NewsBulletinContent extends StatelessWidget {
  const NewsBulletinContent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BulletinBloc, BulletinState>(
      builder: (context, state) {
        return state.headline != null
            ? Container(
                height: DeviceUtil.isTablet ? 55 : 38,
                color: Branding.colors.primaryLight,
                child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Marquee(
                      text: state.headline!,
                      style: TextStyle(color: Colors.white, fontSize: 14.r),
                      scrollAxis: Axis.horizontal,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      blankSpace: 20.0,
                      velocity: 30.0,
                      pauseAfterRound: const Duration(seconds: 0),
                      startPadding: 10.0,
                      accelerationDuration: const Duration(seconds: 1),
                      accelerationCurve: Curves.linear,
                      decelerationDuration: const Duration(milliseconds: 100),
                      decelerationCurve: Curves.easeOut,
                    )),
              )
            : SizedBox.shrink();
      },
    );
  }
}
