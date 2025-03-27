part of 'travel_expense_bloc.dart';

class TravelExpenseState extends Equatable {
  final NetworkStatus? status;
  final TravelExpense? travelExpense;
  final List<String>? modes;
  final List<TravelCategory> categories;
  final List<ExpenseBodyModel> expenseCategoriesData;
  final String? date;
  final int? rating;
  final String? modeOfTransportation;
  final String? categoryName;
  final int? categoryId;
  final List<int>? cIds;
  final List<int>? fileIds;
  final List<double>? amounts;
  final List<String>? remarks;

  const TravelExpenseState(
      {this.status,
      this.travelExpense,
      this.categories = const [],
      this.modes,
      this.date,
      this.remarks,
      this.expenseCategoriesData = const [],
      this.amounts,
      this.rating,
      this.cIds,
      this.fileIds,
      this.modeOfTransportation,
      this.categoryName,
      this.categoryId});

  TravelExpenseState copyWith(
      {NetworkStatus? status,
      TravelExpense? travelExpense,
      List<String>? modes,
      List<TravelCategory>? categories,
      String? date,
      int? rating,
      List<ExpenseBodyModel>? expenseCategoriesData,
      List<int>? cIds,
      List<double>? amounts,
      List<String>? remarks,
      List<int>? fileIds,
      String? modeOfTransportation,
      String? categoryName,
      int? categoryId}) {
    return TravelExpenseState(
        status: status ?? this.status,
        travelExpense: travelExpense ?? this.travelExpense,
        categories: categories ?? this.categories,
        modes: modes ?? this.modes,
        date: date ?? this.date,
        expenseCategoriesData: expenseCategoriesData ?? this.expenseCategoriesData,
        remarks: remarks ?? this.remarks,
        rating: rating ?? this.rating,
        amounts: amounts ?? this.amounts,
        cIds: cIds ?? this.cIds,
        fileIds: fileIds ?? this.fileIds,
        modeOfTransportation: modeOfTransportation ?? this.modeOfTransportation,
        categoryName: categoryName ?? this.categoryName,
        categoryId: categoryId ?? this.categoryId);
  }

  @override
  List<Object?> get props => [
        status,
        travelExpense,
        categories,
        modes,
        date,
        remarks,
        amounts,
        rating,
        cIds,
        fileIds,
        modeOfTransportation,
        categoryName,
        expenseCategoriesData,
        categoryId
      ];
}
