import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meta_club_api/meta_club_api.dart';
import 'package:onesthrm/page/password_change/view/password_change_page.dart';
import 'package:onesthrm/page/profile/view/content/edit_profile_info.dart';
import 'package:core/core.dart';
import 'package:onesthrm/res/nav_utail.dart';
import 'package:onesthrm/res/widgets/custom_button.dart';
import '../../../../res/custom_build_profile_details.dart';
import '../../../../res/widgets/custom_button_widget1.dart';
import '../../bloc/profile/profile_bloc.dart';

class OfficialProfileContent extends StatelessWidget {
  final Profile profile;
  final Settings? settings;

  const OfficialProfileContent(
      {super.key, required this.profile, required this.settings});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          buildProfileDetails(
              title: "name".tr(), description: profile.official?.name ?? "N/A"),
          buildProfileDetails(
              title: "email".tr(),
              description: profile.official?.email ?? "N/A"),
          buildProfileDetails(
              title: "designation".tr(),
              description: profile.official?.designation ?? "N/A"),
          buildProfileDetails(
              title: "department".tr(),
              description: profile.official?.department ?? "N/A"),
          buildProfileDetails(
              title: "manager".tr(),
              description: profile.official?.designation ?? "N/A"),
          buildProfileDetails(
              title: "date_of_joining".tr(),
              description: profile.official?.joiningDate ?? "N/A"),
          buildProfileDetails(
            title: "employee_type".tr(),
            description: profile.official?.employeeType ?? "N/A",
          ),
          buildProfileDetails(
              title: "employee_id".tr(),
              description: profile.official?.employeeId ?? "N/A"),
          const SizedBox(
            height: 24.0,
          ),
          CustomButton1(
            onTap: () {
              Navigator.of(context).push(EditOfficialInfo.route(
                  bloc: context.read<ProfileBloc>(),
                  pageName: 'official',
                  settings: settings,
                  profile: profile));
            },
            text: 'edit_official_info'.tr(),
            radius: 4,
            textSize: 14.r,
          ),
          const SizedBox(
            height: 10,
          ),
          CustomHButton(
            padding: 30,
            backgroundColor: colorPrimary,
            title: "change_password".tr(),
            clickButton: () {
              NavUtil.navigateScreen(context, const PasswordChangePage());
            },
          )
        ],
      ),
    );
  }
}
