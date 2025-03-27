// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:onesthrm/page/attendance_selfie/view/content/selfie_preview_screen.dart';
// import 'package:onesthrm/page/home/bloc/home_bloc.dart';
//
// class AttendanceSelfieScreen extends StatefulWidget {
//   const AttendanceSelfieScreen({super.key, this.cameras});
//   final List<CameraDescription>? cameras;
//
//   @override
//   State<AttendanceSelfieScreen> createState() => _AttendanceSelfieScreenState();
// }
//
// class _AttendanceSelfieScreenState extends State<AttendanceSelfieScreen> {
//   late CameraController controller;
//
//   @override
//   void initState() {
//     super.initState();
//     controller = CameraController(widget.cameras![1], ResolutionPreset.max);
//     controller.initialize().then((_) {
//       if (!mounted) {
//         return;
//       }
//       setState(() {});
//     }).catchError((Object e) {
//       if (e is CameraException) {
//         switch (e.code) {
//           case 'CameraAccessDenied':
//           // Handle access errors here.
//             break;
//           default:
//           // Handle other errors here.
//             break;
//         }
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Stack(children: [
//           (controller.value.isInitialized)
//               ? CameraPreview(controller)
//               : Container(
//               color: Colors.black,
//               child: const Center(child: CircularProgressIndicator())),
//           Align(
//             alignment: Alignment.bottomCenter,
//             child: Container(
//               height: MediaQuery.of(context).size.height * 0.18,
//               width: double.infinity,
//               decoration: const BoxDecoration(color: Colors.black),
//               child: IconButton(
//                 onPressed: takePicture,
//                 iconSize: 80,
//                 padding: EdgeInsets.zero,
//                 constraints: const BoxConstraints(),
//                 icon: const Icon(Icons.circle, color: Colors.white),
//               ),
//             ),
//           ),
//         ]),
//       ),
//     );
//   }
//
//   Future takePicture() async {
//     if (!controller.value.isInitialized) {
//       return null;
//     }
//     if (controller.value.isTakingPicture) {
//       return null;
//     }
//     try {
//       await controller.setFlashMode(FlashMode.off);
//       XFile picture = await controller.takePicture();
//       if (mounted) {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (_) => BlocProvider.value(
//               value: context.read<HomeBloc>(),
//               child: SelfiePreviewScreen(
//                 picture: picture,
//               ),
//             ),
//           ),
//         );
//       }
//     } on CameraException catch (e) {
//       debugPrint('Error occurred while taking picture: $e');
//       return null;
//     }
//   }
// }
