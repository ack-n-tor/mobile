import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meta_club_api/meta_club_api.dart';
import 'package:onesthrm/page/profile/view/content/custom_text_field_with_title.dart';
import 'package:onesthrm/page/select_employee/view/select_employee.dart';
import 'package:onesthrm/page/upload_file/view/upload_doc_content.dart';
import 'package:onesthrm/page/writeup/bloc/verbal_wraning/verbal_warning_bloc.dart';
import 'package:onesthrm/page/writeup/bloc/verbal_wraning/verbal_warning_state.dart';
import 'package:onesthrm/res/widgets/date_picker_widget.dart';

class CreateVerbalWarningContent extends StatelessWidget {

  final Key formKey;

  const CreateVerbalWarningContent({super.key,required this.formKey});

  @override
  Widget build(BuildContext context) {

    return Form(
      key: formKey,
      child: BlocBuilder<VerbalWarningBloc, VerbalWarningState>(
        builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 8.0,
                ),
                CustomTextField(
                  title: "Title",
                  maxLine: 1,
                  errorMsg: "*Required field",
                  controller: context.read<VerbalWarningBloc>().titleController,
                ),
                const SizedBox(
                  height: 8.0,
                ),
                CustomTextField(
                  title: "Description",
                  hints: "Write say something..",
                  errorMsg: "*Required field",
                  maxLine: 4,
                  controller: context.read<VerbalWarningBloc>().descriptionController,
                ),
                const SizedBox(
                  height: 8.0,
                ),
                const Text(
                  "Date",
                  style: TextStyle(color: Colors.black, fontSize: 14, fontWeight: FontWeight.bold),
                ),
                CustomDatePicker(
                  label: state.date ?? 'Select date',
                  onDatePicked: (DateTime date) {
                    context.read<VerbalWarningBloc>().onDateUpdated(date: DateFormat('yyyy-MM-dd').format(date));
                  },
                ),
                const SizedBox(
                  height: 16.0,
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    "complain_to".tr(),
                    style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14.r),
                  ),
                ),
                Card(
                  child: ListTile(
                    onTap: () async {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => const SelectEmployeePage()))
                          .then((employee) {
                        context.read<VerbalWarningBloc>().onEmployeeSelected(employee: employee);
                      });
                    },
                    title: Text(
                      state.employee?.name! ?? tr("add_a_Substitute"),
                      style: TextStyle(fontSize: 16.r),
                    ),
                    subtitle: Text(
                      state.employee?.designation! ?? tr("add_a_Designation"),
                      style: TextStyle(fontSize: 14.r),
                    ),
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(state.employee?.avatar ??
                          'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png'),
                    ),
                    trailing: const Icon(Icons.edit),
                  ),
                ),
                const SizedBox(
                  height: 8.0,
                ),
                UploadDocContent(
                  onFileUpload: (FileUpload? data) {
                    context.read<VerbalWarningBloc>().onDocumentUpdated(document: data?.previewUrl);
                  },
                  initialAvatar: state.document ??
                      "https://upload.wikimedia.org/wikipedia/commons/thumb/d/d1/Image_not_available.png/640px-Image_not_available.png",
                ),
                const SizedBox(
                  height: 16.0,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
