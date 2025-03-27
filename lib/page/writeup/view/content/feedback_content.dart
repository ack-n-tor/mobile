import 'package:core/core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta_club_api/meta_club_api.dart';
import 'package:onesthrm/page/writeup/bloc/complain_details/complain_details_bloc.dart';
import 'package:onesthrm/page/writeup/bloc/complain_details/complain_details_state.dart';
import 'package:onesthrm/res/widgets/custom_button.dart';

class FeedbackContent extends StatelessWidget {
  final Complain complain;

  const FeedbackContent({super.key, required this.complain});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ComplainDetailsBloc, ComplainDetailsState>(
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (state.complainReplies.isEmpty && state.submitComplain == NetworkStatus.success) ...[
              const Padding(
                  padding: EdgeInsets.only(left: 16.0, bottom: 8.0, top: 16.0),
                  child: Text("Feedback:",
                      style: TextStyle(color: Colors.black, fontSize: 15.0, fontWeight: FontWeight.bold))),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Row(
                  children: [
                    TextButton(
                        onPressed: () {
                          context.read<ComplainDetailsBloc>().onAppeal();
                        },
                        style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all<Color>(
                                state.isAppeal == true ? Branding.colors.primaryLight : Colors.white),
                            padding: WidgetStateProperty.all<EdgeInsets>(const EdgeInsets.symmetric(horizontal: 16.0)),
                            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)))),
                        child: Text('Appeal',
                            style: TextStyle(color: state.isAppeal == true ? Colors.white : Colors.black))),
                    const SizedBox(width: 24.0),
                    TextButton(
                        onPressed: () {
                          context.read<ComplainDetailsBloc>().onAppeal(isAppeal: false);
                        },
                        style: ButtonStyle(
                            backgroundColor: WidgetStateProperty.all<Color>(
                                state.isAgree == true ? Branding.colors.primaryLight : Colors.white),
                            padding: WidgetStateProperty.all<EdgeInsets>(const EdgeInsets.symmetric(horizontal: 24.0)),
                            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(borderRadius: BorderRadius.circular(6.0)))),
                        child: Text('Agree',
                            style: TextStyle(color: state.isAgree == true ? Colors.white : Colors.black))),
                  ],
                ),
              ),
            ],
            if (state.isAppeal == true) ...[
              const SizedBox(height: 8.0),
              CheckboxListTile(
                shape: const CircleBorder(),
                title: const Text("Write explanation"),
                value: state.writeExplanation,
                dense: true,
                onChanged: (_) {
                  context.read<ComplainDetailsBloc>().onExplanation(isExplain: !state.writeExplanation);
                },
                controlAffinity: ListTileControlAffinity.leading, //  <-- leading Checkbox
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextFormField(
                    controller: context.read<ComplainDetailsBloc>().explanationController,
                    minLines: 5,
                    maxLines: 20,
                    readOnly: state.directTalkHR == true || state.writeExplanation == false,
                    keyboardType: TextInputType.multiline,
                    decoration: const InputDecoration(
                        hintText: 'Explanation..',
                        hintStyle: TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))))),
              ),
              CheckboxListTile(
                title: const Text("Direct talk with HR"),
                value: state.directTalkHR,
                dense: true,
                shape: const CircleBorder(),
                onChanged: (_) {
                  context.read<ComplainDetailsBloc>().onDirectHR(directHR: !state.directTalkHR);
                },
                controlAffinity: ListTileControlAffinity.leading,
              )
            ],
            if (state.isAgree == true) ...[
              const Padding(
                  padding: EdgeInsets.only(left: 16.0, top: 24.0),
                  child: Text("I acknowledge this complaint and accept it without further explanation",
                      style: TextStyle(color: Colors.red, fontSize: 13.0, fontWeight: FontWeight.bold))),
              const SizedBox(height: 32.0),
            ],
            Align(
              alignment: Alignment.bottomRight,
              child: CustomHButton(
                title: "Submit".tr(),
                isLoading: state.submitComplain == NetworkStatus.loading,
                padding: 16,
                clickButton: () async {
                  if (complain.id != null) {
                    context.read<ComplainDetailsBloc>().submitComplainReply(complainId: complain.id!);
                  }
                },
              ),
            ),
            const SizedBox(height: 32.0),
          ],
        );
      },
    );
  }
}
