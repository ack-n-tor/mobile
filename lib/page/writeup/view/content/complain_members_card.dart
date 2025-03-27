import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:core/core.dart';

class ComplainMembersCard extends StatelessWidget {
  final List<String?> items;
  final Function(int) onItemRemoved;

  const ComplainMembersCard({super.key, required this.items,required this.onItemRemoved});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
            children: List.generate(
                items.length,
                (int index) => Container(
                    margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        gradient: const LinearGradient(
                            colors: [Color(0xFF00CCFF), colorPrimary],
                            begin: FractionalOffset(2.0, 0.0),
                            end: FractionalOffset(0.0, 1.0),
                            stops: [0.0, 1.0],
                            tileMode: TileMode.clamp)),
                    child: Row(
                      children: [
                        Text(items[index] ?? "",
                            style: TextStyle(fontSize: 12.r, color: Colors.white, fontWeight: FontWeight.w500)),
                        SizedBox(width: 5),
                        InkWell(
                            onTap:()=> onItemRemoved(index),
                            child: Icon(CupertinoIcons.clear, size: 18, color: Colors.white))
                      ],
                    )))));
  }
}
