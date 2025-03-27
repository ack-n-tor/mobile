import 'dart:async';
import 'package:core/core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:meta_club_api/meta_club_api.dart';
import 'package:onesthrm/page/travel/bloc/travel_expense_bloc/travel_expense_bloc.dart';
import 'package:onesthrm/page/travel/travel_expense_view/add_expense_screen.dart';
import 'package:onesthrm/page/travel/travel_expense_view/contents/expense_category_card.dart';
import 'package:onesthrm/res/widgets/custom_button.dart';
import 'package:onesthrm/res/widgets/date_picker_widget.dart';

class SubmitTravelExpenseScreen extends StatefulWidget {
  const SubmitTravelExpenseScreen({super.key});

  @override
  State<SubmitTravelExpenseScreen> createState() => _SubmitTravelExpenseScreenState();
}

class _SubmitTravelExpenseScreenState extends State<SubmitTravelExpenseScreen> {
  late StreamSubscription<TravelExpenseState> travelSubscription;

  @override
  void initState() {
    super.initState();
    final categories = context.read<TravelExpenseBloc>().state.categories;
    context.read<TravelExpenseBloc>().add(TravelCategoryNameEvent(categoryName: categories.first.name!, categoryId: categories.first.id!));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Travel Expense")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              Text('From Date *', style: TextStyle(color: Colors.black, fontSize: 12.r, fontWeight: FontWeight.bold)),
              CustomDatePicker(
                label: context.watch<TravelExpenseBloc>().state.date ?? 'MM-DD-YYYY',
                onDatePicked: (DateTime date) {
                  context.read<TravelExpenseBloc>().add(OnSelectDate(date: DateFormat('yyyy-MM-dd').format(date)));
                },
              ),
              const SizedBox(height: 16.0),
              Text('Expense Info:', style: TextStyle(color: Colors.grey, fontSize: 13.r, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8.0),
              BlocBuilder<TravelExpenseBloc, TravelExpenseState>(
                builder: (context, state) {
                  return state.expenseCategoriesData.isNotEmpty
                      ? ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: state.expenseCategoriesData.length,
                          itemBuilder: (context, index) {
                            ExpenseBodyModel? categoryData = state.expenseCategoriesData[index];
                            return ExpenseCategoryCard(categoryData: categoryData, index: index);
                          },
                        )
                      : const SizedBox.shrink();
                },
              ),
              const SizedBox(height: 8.0),
              CustomHButton(
                padding: 0,
                backgroundColor: Branding.colors.primaryLight,
                title: tr("Add Expense"),
                clickButton: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (ctx) =>
                              BlocProvider.value(value: context.read<TravelExpenseBloc>(), child: AddExpenseScreen())));
                },
              ),
              const SizedBox(height: 16.0),
              RatingBar.builder(
                initialRating: 0,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: false,
                itemCount: 5,
                itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.amber),
                onRatingUpdate: (rating) {
                  context.read<TravelExpenseBloc>().add(OnReviewChanged(rating: rating.ceil()));
                },
              ),
              const SizedBox(height: 16),
              BlocBuilder<TravelExpenseBloc, TravelExpenseState>(
                builder: (context, state) {
                  return CustomHButton(
                    padding: 0,
                    backgroundColor: Branding.colors.primaryLight,
                    title: tr("Submit"),
                    isLoading: state.status == NetworkStatus.loading,
                    clickButton: () {
                      final remarks = state.expenseCategoriesData.map((e) => e.remark ?? "").toList();
                      final titles = state.expenseCategoriesData.map((e) => e.title ?? "").toList();
                      final amounts = state.expenseCategoriesData.map((e) => double.parse(e.amount ?? "0")).toList();
                      final categoryIds = state.expenseCategoriesData.map((e) => e.categoryId ?? 0).toList();
                      final imageIds = state.expenseCategoriesData.map((e) => e.imageId ?? 0).toList();

                      context.read<TravelExpenseBloc>().add(OnExpenseSubmit(
                          context: context,
                          cIds: categoryIds,
                          fileIds: imageIds,
                          amounts: amounts,
                          remarks: remarks,
                          title: titles));
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
