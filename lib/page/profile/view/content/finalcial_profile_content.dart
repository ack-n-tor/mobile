import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meta_club_api/meta_club_api.dart';
import '../../../../res/custom_build_profile_details.dart';
import '../../../../res/widgets/custom_button_widget1.dart';
import '../../bloc/profile/profile_bloc.dart';
import 'edit_profile_info.dart';

class FinancialProfileContent extends StatelessWidget {
  final Profile profile;
  final Settings? settings;

  const FinancialProfileContent(
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
              title: "tin".tr(), description: profile.financial?.tin ?? "N/A"),
          buildProfileDetails(
              title: "bank_name".tr(),
              description: profile.financial?.bankName ?? "N/A"),
          buildProfileDetails(
              title: "bank_account_no".tr(),
              description: profile.financial?.bankAccount ?? "N/A"),
          const SizedBox(
            height: 16.0,
          ),
          CustomButton1(
            onTap: () {
              Navigator.of(context).push(EditOfficialInfo.route(
                  bloc: context.read<ProfileBloc>(),
                  pageName: 'financial',
                  settings: settings,
                  profile: profile));
            },
            text: 'editFinancial_info'.tr(),
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
