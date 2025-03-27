import 'package:core/core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:onesthrm/page/travel/bloc/travel_meeting_bloc/travel_meeting_bloc.dart';
import 'package:onesthrm/page/travel/travel_meeting_view/contect/company_name_widget.dart';
import 'package:onesthrm/page/travel/travel_meeting_view/contect/customer_full_name.dart';
import 'package:onesthrm/page/travel/travel_meeting_view/contect/email_widget.dart';
import 'package:onesthrm/page/travel/travel_meeting_view/contect/end_time_widget.dart';
import 'package:onesthrm/page/travel/travel_meeting_view/contect/error_text_widget.dart';
import 'package:onesthrm/page/travel/travel_meeting_view/contect/file_upload_widget.dart';
import 'package:onesthrm/page/travel/travel_meeting_view/contect/phone_widget.dart';
import 'package:onesthrm/page/travel/travel_meeting_view/contect/purpose_of_travel_widget.dart';
import 'package:onesthrm/page/travel/travel_meeting_view/contect/rating_bar_widget.dart';
import 'package:onesthrm/page/travel/travel_meeting_view/contect/remark_widget.dart';
import 'package:onesthrm/page/travel/travel_meeting_view/contect/schedule_time_widget.dart';
import 'package:onesthrm/page/travel/travel_meeting_view/contect/select_travel_date_widget.dart';
import 'package:onesthrm/page/travel/travel_meeting_view/contect/start_time_widget.dart';
import 'package:onesthrm/res/widgets/custom_button.dart';

class CreateTravelMeeting extends StatelessWidget {
  const CreateTravelMeeting({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(title: const Text("Create Travel Meeting")),
        body: BlocBuilder<TravelMeetingBloc, TravelMeetingState>(
            builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// Select Travel Date Widget
                  SelectTravelDateWidget(state: state),
                  /// Company Name Widget
                  const CompanyNameWidget(),
                  /// Full Name widget
                  const CustomerFullName(),
                  /// email widget
                  const EmailWidget(),
                  /// phone widget
                  const PhoneWidget(),
                  /// purpose widget
                  const PurposeOfTravelWidget(),
                  /// Schedule Time Widget
                  ScheduleTimeWidget(state: state),
                  /// Start Time Widget
                  StartTimeWidget(state: state),
                  /// End Time Widget
                  EndTimeWidget(state: state),
                  /// Remark Widget
                  const RemarkWidget(),
                  /// File upload widget
                  const FileUploadWidget(),
                  /// Rating Bar Widget
                  const RatingBarWidget(),
                  /// Error Text Widget
                  ErrorTextWidget(state: state),
                  /// Button Widget
                  CustomHButton(
                    isLoading: state.status == NetworkStatus.loading,
                    padding: 0, backgroundColor: Branding.colors.primaryLight,
                    title: tr("Submit"),
                    clickButton: () {
                      context.read<TravelMeetingBloc>().add(SubmitButton(context: context));
                    },
                  ),
                ],
              ),
            ),
          );
        }));
  }
}
