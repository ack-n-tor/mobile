import 'package:core/core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onesthrm/page/deduction/view/deduction_screen.dart';
import 'package:onesthrm/page/language/bloc/language_bloc.dart';
import 'package:onesthrm/page/writeup/view/complain_page.dart';
import 'package:onesthrm/page/writeup/view/verbal_warning_page.dart';
import 'package:onesthrm/res/nav_utail.dart';

class MenuSettingsContent extends StatelessWidget {
  const MenuSettingsContent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LanguageBloc, LanguageState>(
      builder: (_, __) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 10.0.r,
            ),
            ListTile(
              onTap: () {
                final deductScreen = instance<DeductionScreenFactory>();
                NavUtil.navigateScreen(context, deductScreen());
              },
              dense: true,
              contentPadding: EdgeInsets.zero,
              horizontalTitleGap: 8.r,
              leading: const Icon(Icons.price_change_outlined),
              title: Text(
                "Deduction",
                style: TextStyle(fontSize: 14.r),
              ).tr(),
            ),
            ListTile(
              onTap: () {
                NavUtil.navigateScreen(context, const ComplainPage());
              },
              dense: true,
              contentPadding: EdgeInsets.zero,
              horizontalTitleGap: 8.r,
              leading: const Icon(Icons.help_center_outlined),
              title: Text(
                "complains",
                style: TextStyle(fontSize: 14.r),
              ).tr(),
            ),
            ListTile(
              onTap: () {
                NavUtil.navigateScreen(context, const VerbalWarningPage());
              },
              dense: true,
              contentPadding: EdgeInsets.zero,
              horizontalTitleGap: 8.r,
              leading: const Icon(Icons.help_center_outlined),
              // leading: SvgPicture.asset(
              //   'assets/menu_drawer_icons/language-change.svg',height: 20.r,width: 20.r,),
              title: Text(
                "verbal_warning",
                style: TextStyle(fontSize: 14.r),
              ).tr(),
            ),
          ],
        );
      },
    );
  }
}
