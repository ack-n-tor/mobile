import 'package:core/core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta_club_api/meta_club_api.dart';
import 'package:onesthrm/page/document/view/content/custom_drop_down.dart';
import 'package:onesthrm/page/profile/view/content/custom_text_field_with_title.dart';
import 'package:onesthrm/page/travel/bloc/travel_expense_bloc/travel_expense_bloc.dart';
import 'package:onesthrm/page/upload_file/view/upload_doc_content.dart';
import 'package:onesthrm/res/widgets/custom_button.dart';

class TravelExpenseInfoCard extends StatelessWidget {
  const TravelExpenseInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    ExpenseBodyModel expenseBodyModel = ExpenseBodyModel();
    return Card(
      elevation: 0.0,
      margin: const EdgeInsets.only(bottom: 8.0),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
        child: SingleChildScrollView(
          child: Column(
            children: [
              BlocBuilder<TravelExpenseBloc, TravelExpenseState>(
                builder: (context, state) {
                  return CustomCategoryDropDown(
                    item: state.categoryName,
                    items: state.categories,
                    title: 'Category*',
                    onChange: (TravelCategory? category) {
                      if (category != null) {
                        expenseBodyModel.categoryName = category.name;
                        expenseBodyModel.categoryId = category.id;
                        context.read<TravelExpenseBloc>().add(TravelCategoryNameEvent(categoryName: category.name!,categoryId: category.id!));
                      }
                    },
                  );
                },
              ),
              SizedBox(height: 16),
              CustomTextField(
                title: "Title*",
                value: '',
                textInputType: TextInputType.text,
                hints: "Enter title",
                onData: (String? title) {
                  expenseBodyModel.title = title;
                },
              ),
              const SizedBox(height: 8.0),
              CustomTextField(
                  title: "Amount*",
                  value: '',
                  textInputType: TextInputType.number,
                  hints: "Enter the amount that you have spent",
                  onData: (String? amount) {
                    expenseBodyModel.amount = amount;
                  }),
              const SizedBox(height: 8.0),
              UploadDocContent(
                buttonText: "File Upload",
                onFileUpload: (FileUpload? file) {
                  if (file != null) {
                    expenseBodyModel.imageURL = file.previewUrl;
                    expenseBodyModel.imageId = file.fileId;
                  }
                },
                initialAvatar: "https://upload.wikimedia.org/wikipedia/commons/thumb/d/d1/Image_not_available.png/640px-Image_not_available.png",
              ),
              const SizedBox(height: 16.0),
              CustomTextField(
                  title: "Remark * ",
                  value: '',
                  sizedBoxHeight: 8.0,
                  hints: "Remark",
                  onData: (String? remark) {
                    expenseBodyModel.remark = remark;
                  }),
              const SizedBox(height: 16.0),
              CustomHButton(
                padding: 0,
                backgroundColor: Branding.colors.primaryLight,
                title: tr("Add Expense"),
                clickButton: () {
                  context.read<TravelExpenseBloc>().add(AddExpenseEvent(addExpenseBodyModel: expenseBodyModel));
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
