import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meta_club_api/meta_club_api.dart';
import '../../../../res/custom_build_profile_details.dart';
import '../../../../res/widgets/custom_button_widget1.dart';
import '../../bloc/profile/profile_bloc.dart';
import 'edit_profile_info.dart';

class PersonalProfileContent extends StatelessWidget {
  final Profile profile;
  final Settings? settings;

  const PersonalProfileContent({super.key, required this.profile, this.settings});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          buildProfileDetails(
              title: "gender".tr(),
              description: profile.personal?.gender ?? "N/A"),
          buildProfileDetails(
              title: "phone".tr(),
              description: profile.personal?.phone ?? "N/A"),
          buildProfileDetails(
              title: "date_of_birth".tr(),
              description: profile.personal?.birthDate ?? "N/A"),
          buildProfileDetails(
              title: "address".tr(),
              description: profile.personal?.address ?? "N/A"),
          buildProfileDetails(
              title: "nationality".tr(),
              description: profile.personal?.nationality ?? "N/A"),
          buildProfileDetails(
              title: "passport".tr(),
              description: profile.personal?.passport ?? "N/A"),
          buildProfileDetails(
              title: "blood".tr(),
              description: profile.personal?.bloodGroup ?? "N/A"),
          const SizedBox(
            height: 16.0,
          ),
          CustomButton1(
            onTap: () {
              Navigator.of(context).push(EditOfficialInfo.route(
                  bloc: context.read<ProfileBloc>(),
                  pageName: 'personal',
                  settings: settings,
                  profile: profile));
            },
            text: 'edit_personal_info'.tr(),
            textSize: 14.r,
          ),
          const SizedBox(
            height: 24.0,
          ),
        ],
      ),
    );
  }
}
