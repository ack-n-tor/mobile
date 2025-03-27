// import 'dart:io';
//
// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:onesthrm/page/attendance/attendance.dart';
// import 'dart:math' as math;
//
// import 'package:onesthrm/res/widgets/custom_button.dart';
//
// import '../../../home/home.dart';
//
// class SelfiePreviewScreen extends StatelessWidget {
//   const SelfiePreviewScreen({super.key, required this.picture});
//
//   final XFile picture;
//
//   @override
//   Widget build(BuildContext context) {
//     const double mirror = math.pi;
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Selected Image'),
//       ),
//       body: Column(mainAxisSize: MainAxisSize.max, children: [
//         SizedBox(
//           height: MediaQuery.of(context).size.height * .8,
//           width: double.infinity,
//           child: Transform(
//               alignment: Alignment.center,
//               transform: Matrix4.rotationY(mirror),
//               child: Image.file(File(picture.path), fit: BoxFit.cover)),
//         ),
//         const SizedBox(height: 24),
//         CustomButton(
//           title: "Next",
//           clickButton: () {
//             Navigator.pushReplacement(
//                 context,
//                 AttendancePage.route(
//                     homeBloc: context.read<HomeBloc>(), selfie: picture.path));
//           },
//         ),
//       ]),
//     );
//   }
// }
