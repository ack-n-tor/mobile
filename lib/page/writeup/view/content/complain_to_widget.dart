import 'package:core/core.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:onesthrm/page/multi_selection_employee/multi_selection_employee_page.dart';
import 'package:onesthrm/page/writeup/bloc/complain/complain_bloc.dart';

class ComplainToWidget extends StatelessWidget {
  const ComplainToWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final complainBloc = context.read<ComplainBloc>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8.0),
        Text(
          tr("Complain To"),
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 14.r),
        ),
        const SizedBox(height: 10),
        Card(
          color: colorCardBackground,
          elevation: 0,
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4).r,
            onTap: () async {
              if (complainBloc.state.selectedNames.isNotEmpty == true) {
                complainBloc.state.selectedNames.clear();
                complainBloc.state.selectedIds.clear();
              }

              /// Get Selected Employee List
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MultiSelectionEmployee(
                      isComplainTo: true,
                      onItemSelected: (items) {
                        final memberIds = items.map((e) => e.id!).toList();
                        final memberNames = items.map((e) => e.name!).toList();
                        context.read<ComplainBloc>().onMemberIdSelected(memberIds: memberIds, memberNames: memberNames);
                      },
                    ),
                  ));
            },
            title: Text(tr("Add Member"), style: TextStyle(fontSize: 14.r)),
            leading: const CircleAvatar(
                backgroundImage: NetworkImage(
                    'https://upload.wikimedia.org/wikipedia/commons/7/7c/Profile_avatar_placeholder_large.png')),
            trailing: const Icon(Icons.add),
          ),
        ),
      ],
    );
  }
}
