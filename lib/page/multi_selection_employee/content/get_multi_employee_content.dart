import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onesthrm/page/multi_selection_employee/content/multi_select_employee_list.dart';

import '../../phonebook/bloc/phonebook_bloc.dart';
import '../../select_employee/content/employee_search.dart';

class GetMultiEmployeeContent extends StatelessWidget {
  final bool? isComplainTo;

  const GetMultiEmployeeContent({super.key, this.isComplainTo });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        isComplainTo == true ? SizedBox.shrink() : EmployeeSearch(bloc: context.read<PhoneBookBloc>()),
        Text(
          "** Please, long press to select employee **",
          style: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 10.r, color: Colors.green),
        ),
        const Expanded(child: MultiSelectEmployeeList()),
      ],
    );
  }
}
