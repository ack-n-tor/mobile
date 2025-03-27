import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onesthrm/page/profile/view/content/custom_text_field_with_validation.dart';
import 'package:onesthrm/page/travel/bloc/travel_meeting_bloc/travel_meeting_bloc.dart';

class EmailWidget extends StatelessWidget {
  const EmailWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextFieldWithValidation(
          title: "E-mail *",
          hints: "ex: muname@example.com",
          textInputType: TextInputType.emailAddress,
          validator: (val) => val?.isEmpty == true ? "*Required field" : null,
          controller: context.read<TravelMeetingBloc>().emailController,
        ),
        const SizedBox(
          height: 16,
        ),
      ],
    );
  }
}
