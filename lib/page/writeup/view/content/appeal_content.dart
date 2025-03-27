import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:meta_club_api/meta_club_api.dart';
import 'package:onesthrm/page/writeup/view/content/feedback_content.dart';
import 'package:onesthrm/page/writeup/view/content/reply_content.dart';


class AppealContent extends StatelessWidget {
  final Complain complain;

  const AppealContent({super.key, required this.complain});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ReplyContent(complain: complain),
        FeedbackContent(complain: complain)
      ],
    );
  }
}
