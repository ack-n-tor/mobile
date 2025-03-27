import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta_club_api/src/models/body_registration.dart';
import 'package:meta_club_api/src/models/response_qualification.dart';

class QualificationCubit extends Cubit<QualificationState>{

  QualificationCubit() : super(const QualificationState());

  void onQualificationChanged(Datum? datum,List<Qualification> qualificationItems){
    return emit(QualificationState(qualificationItems: qualificationItems,datum: datum));
  }
}


class QualificationState{

  final List<Qualification> qualificationItems;
  final Datum? datum;

  const  QualificationState({this.qualificationItems = const [],this.datum});
}