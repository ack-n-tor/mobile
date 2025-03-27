import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_attendance/src/bloc/qr_attendance_bloc.dart';
import 'package:qr_attendance/src/res/enum.dart';

class QRAttendanceContent extends StatefulWidget {
  const QRAttendanceContent({super.key});

  @override
  State<QRAttendanceContent> createState() => _QRAttendanceContentState();
}

class _QRAttendanceContentState extends State<QRAttendanceContent> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QRAttendanceBloc, QRAttendanceState>(
      builder: (context, state) {
        return Stack(
          children: [
            Column(
              children: [
                SafeArea(
                  child: Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      onPressed: () {
                        context.read<QRAttendanceBloc>().qrViewController.start();
                      },
                      icon: const Icon(
                        Icons.refresh,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Expanded(flex: 4, child: _buildQrView(context)),
              ],
            ),
            if (state.status == NetworkStatus.loading) const Center(child: CircularProgressIndicator()),
          ],
        );
      },
    );
  }

  Widget _buildQrView(BuildContext context) {
    return MobileScanner(
      controller: context.read<QRAttendanceBloc>().qrViewController,
      onDetect: (event) {
        final barcode = event.barcodes.first;
        if (barcode.rawValue != null && mounted) {
          context.read<QRAttendanceBloc>().add(QRScanData(qrData: barcode.rawValue, context: context));
          context.read<QRAttendanceBloc>().qrViewController.stop();
        }
      },
    );
  }

  @override
  void dispose() {
    context.read<QRAttendanceBloc>().qrViewController.dispose();
    super.dispose();
  }
}
