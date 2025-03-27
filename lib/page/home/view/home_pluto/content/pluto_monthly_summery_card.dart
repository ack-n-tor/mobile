import 'package:core/core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meta_club_api/meta_club_api.dart';

class PlutoMonthlyEventCard extends StatelessWidget {
  const PlutoMonthlyEventCard({super.key, required this.data, this.days = false, this.onPressed});

  final CurrentMonthData? data;
  final bool? days;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0),
      child: Card(
        elevation: 0.0,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6.0),
            side: BorderSide(color: Branding.colors.primaryLight.withOpacity(0.5))),
        child: TextButton(
          onPressed: onPressed,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6.0),
            child: SizedBox(
              width: 100.w,
              child: Column(
                children: [
                  Image.network(
                    '${data?.image}',
                    height: 20.h,
                    color: Branding.colors.primaryLight,
                  ),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.end,
                    children: [
                      Text(
                        '${data?.number}',
                        style: TextStyle(color: Branding.colors.primaryLight,fontSize: 20.r, fontWeight: FontWeight.w500, height: 1.5, letterSpacing: 0.5),
                      ),
                      if (days == true)
                        Text(
                          'days'.tr(),
                          style: TextStyle(
                              color: const Color(0xFF777777),
                              fontSize: 12.r,
                              fontWeight: FontWeight.w500,
                              height: 4,
                              letterSpacing: 0.5),
                        ),
                    ],
                  ),
                  Text(
                    data?.title ?? '',
                    maxLines: 1,
                    style: TextStyle(color: Branding.colors.primaryLight,fontSize: 14.r, fontWeight: FontWeight.w500, height: 1.5, letterSpacing: 0.5),
                  ).tr(),
                  const SizedBox(
                    height: 6,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
