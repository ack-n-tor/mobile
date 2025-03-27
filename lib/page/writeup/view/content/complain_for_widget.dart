import 'package:core/core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onesthrm/page/select_employee/view/select_employee.dart';
import 'package:onesthrm/page/writeup/bloc/complain/complain_bloc.dart';
import 'package:onesthrm/page/writeup/bloc/complain/complain_state.dart';

class ComplainForWidget extends StatelessWidget {
  const ComplainForWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ComplainBloc, ComplainState>(builder: (context, state) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text("Complain For",
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14.r))),
          Card(
            color: colorCardBackground,
            elevation: 0,
            child: ListTile(
              onTap: () async {
                Navigator.push(
                        context, MaterialPageRoute(builder: (context) => const SelectEmployeePage(complainFor: true)))
                    .then((employee) {
                  if (context.mounted) {
                    context.read<ComplainBloc>().onEmployeeSelected(employee: employee);
                  }
                });
              },
              title: Text(state.employee?.name! ?? tr("Add Member"), style: TextStyle(fontSize: 14.r)),
              subtitle: Text(state.employee?.designation! ?? tr("add_a_Designation"),
                  style: TextStyle(fontSize: 12.r, color: Colors.grey)),
              leading: CircleAvatar(
                  backgroundImage: NetworkImage(state.employee?.avatar ??
                      'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png')),
              trailing: const Icon(Icons.edit),
            ),
          ),
          const SizedBox(height: 8.0),
        ],
      );
    });
  }
}
