import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta_club_api/meta_club_api.dart';
import 'package:onesthrm/page/profile/view/content/custom_text_field_with_title.dart';
import 'package:onesthrm/page/upload_file/view/upload_doc_content.dart';
import 'package:onesthrm/page/writeup/bloc/complain/complain_bloc.dart';
import 'package:onesthrm/page/writeup/bloc/complain/complain_state.dart';
import 'package:onesthrm/page/writeup/view/content/complain_for_widget.dart';
import 'package:onesthrm/page/writeup/view/content/complain_to_widget.dart';
import 'package:onesthrm/res/widgets/date_picker_widget.dart';
import 'complain_members_card.dart';

class CreateComplainContent extends StatelessWidget {
  final Key formKey;

  const CreateComplainContent({super.key, required this.formKey});

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: BlocBuilder<ComplainBloc, ComplainState>(
        builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8.0),
                CustomTextField(
                    title: "Title",
                    maxLine: 1,
                    errorMsg: "*Required field",
                    controller: context.read<ComplainBloc>().titleController),
                const SizedBox(height: 8.0),
                CustomTextField(
                    title: "Description",
                    hints: "Write say something..",
                    errorMsg: "*Required field",
                    maxLine: 4,
                    controller: context.read<ComplainBloc>().descriptionController),
                const SizedBox(height: 8.0),
                const Text("Date", style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold)),
                CustomDatePicker(
                  label: state.date ?? 'Select date',
                  onDatePicked: (DateTime date) {
                    context.read<ComplainBloc>().onDateUpdated(date: DateFormat('yyyy-MM-dd').format(date));
                  },
                ),
                const SizedBox(height: 8.0),
                ComplainToWidget(),
                ComplainMembersCard(
                  items: state.selectedNames,
                  onItemRemoved: (index) {
                    state.selectedNames.removeAt(index);
                    context.read<ComplainBloc>().onMemberRemoved(names:  ['']);
                    context.read<ComplainBloc>().onMemberRemoved(names:  state.selectedNames);
                  },
                ),
                const SizedBox(height: 16),
                ComplainForWidget(),
                UploadDocContent(
                  onFileUpload: (FileUpload? data) {
                    context.read<ComplainBloc>().onDocumentUpdated(document: data?.previewUrl);
                  },
                  initialAvatar: state.document ??
                      "https://upload.wikimedia.org/wikipedia/commons/thumb/d/d1/Image_not_available.png/640px-Image_not_available.png",
                ),
                const SizedBox(height: 16.0),
              ],
            ),
          );
        },
      ),
    );
  }
}
