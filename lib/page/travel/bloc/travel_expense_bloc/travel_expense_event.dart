part of 'travel_expense_bloc.dart';

abstract class TravelExpenseEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class RemoveExpenseItemEvent extends TravelExpenseEvent {
  final int index;

  RemoveExpenseItemEvent({required this.index});

  @override
  List<Object> get props => [index];
}

class TravelExpenseEventLoad extends TravelExpenseEvent {
  @override
  List<Object> get props => [];
}

class OnTravelModeLoadEvent extends TravelExpenseEvent {
  @override
  List<Object> get props => [];
}

class TravelModeEvent extends TravelExpenseEvent {
  final String mode;

  TravelModeEvent({required this.mode});

  @override
  List<Object> get props => [mode];
}

class TravelCategoryNameEvent extends TravelExpenseEvent {
  final String categoryName;
  final int categoryId;

  TravelCategoryNameEvent({required this.categoryName,required this.categoryId});

  @override
  List<Object> get props => [categoryName,categoryId];
}

class AddExpenseEvent extends TravelExpenseEvent {
  final ExpenseBodyModel addExpenseBodyModel;

  AddExpenseEvent({required this.addExpenseBodyModel});

  @override
  List<Object> get props => [addExpenseBodyModel];
}

class TravelCategoryEvent extends TravelExpenseEvent {
  @override
  List<Object> get props => [];
}

class OnSelectDate extends TravelExpenseEvent {
  final String date;

  OnSelectDate({required this.date});

  @override
  List<Object> get props => [date];
}

class OnReviewChanged extends TravelExpenseEvent {
  final int rating;

  OnReviewChanged({required this.rating});

  @override
  List<Object> get props => [rating];
}

class OnExpenseSubmit extends TravelExpenseEvent {
  final BuildContext context;
  final GlobalKey<SfSignaturePadState>? signaturePadKey;
  final List<int> cIds;
  final List<int> fileIds;
  final List<double> amounts;
  final List<String> remarks;
  final List<String> title;

  OnExpenseSubmit(
      {required this.context,
      this.signaturePadKey,
      required this.cIds,
      required this.fileIds,
      required this.amounts,
      required this.title,
      required this.remarks});

  @override
  List<Object> get props => [context];
}
