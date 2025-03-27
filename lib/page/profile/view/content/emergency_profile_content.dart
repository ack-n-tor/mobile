import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meta_club_api/meta_club_api.dart';
import '../../../../res/custom_build_profile_details.dart';
import '../../../../res/widgets/custom_button_widget1.dart';
import '../../bloc/profile/profile_bloc.dart';
import 'edit_profile_info.dart';

class EmergencyProfileContent extends StatelessWidget {
  final Profile profile;
  final Settings? settings;

  const EmergencyProfileContent(
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
              title: "name".tr(),
              description: profile.emergency?.name ?? "N/A"),
          buildProfileDetails(
              title: "mobile_number".tr(),
              description: profile.emergency?.mobile ?? "N/A"),
          buildProfileDetails(
              title: "relationship".tr(),
              description: profile.emergency?.relationship ?? "N/A"),
          const SizedBox(
            height: 16.0,
          ),
          CustomButton1(
            onTap: () {
              Navigator.of(context).push(EditOfficialInfo.route(
                  bloc: context.read<ProfileBloc>(),
                  pageName: 'emergency',
                  settings: settings,
                  profile: profile));
            },
            text: 'edit_emergency_info'.tr(),
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
