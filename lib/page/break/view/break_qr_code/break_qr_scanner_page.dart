import 'dart:async';
import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:onesthrm/page/break/bloc/break_bloc.dart';
import 'package:onesthrm/page/break/view/break_back_type_screen.dart';
import 'package:onesthrm/page/break/view/content/break_report_screen.dart';
import 'package:onesthrm/page/break/view/content/qr_app_bar.dart';
import 'package:onesthrm/page/home/bloc/home_bloc.dart';

class BreakQrScannerPage extends StatefulWidget {
  final HomeBloc homeBloc;

  const BreakQrScannerPage({super.key, required this.homeBloc});

  @override
  State<BreakQrScannerPage> createState() => _BreakQrScannerPageState();
}

class _BreakQrScannerPageState extends State<BreakQrScannerPage> with WidgetsBindingObserver {
  final controller = MobileScannerController(
    facing: CameraFacing.back,
    detectionSpeed: DetectionSpeed.normal,
    torchEnabled: false,
  );
  StreamSubscription<Object?>? _subscription;
  bool qrFound = true;

  @override
  void initState() {
    super.initState();
    // Start listening to lifecycle changes.
    WidgetsBinding.instance.addObserver(this);

    // Finally, start the scanner itself.
    unawaited(controller.start());
  }

  @override
  void reassemble() {
    super.reassemble();
    controller.start();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // If the controller is not ready, do not try to start or stop it.
    // Permission dialogs can trigger lifecycle changes before the controller is ready.
    if (!controller.value.hasCameraPermission) {
      return;
    }

    switch (state) {
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
      case AppLifecycleState.paused:
        return;
      case AppLifecycleState.resumed:
        // Restart the scanner when the app is resumed.
        // Don't forget to resume listening to the barcode events.
        // _subscription = controller.barcodes.listen(_handleBarcode);

        unawaited(controller.start());
      case AppLifecycleState.inactive:
        // Stop the scanner when the app is paused.
        // Also stop the barcode events subscription.
        unawaited(_subscription?.cancel());
        _subscription = null;
        unawaited(controller.stop());
    }
  }

  @override
  Widget build(BuildContext context) {
    final breakBackBloc = instance<BreakBlocFactory>();

    return BlocProvider(
      create: (_) => breakBackBloc()..add(GetBreakHistoryData()),
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(0.0),
            child: AppBar(automaticallyImplyLeading: false),
          ),
          body: Column(
            children: [
              QrAppBar(
                onCameraRefresh: () {
                  controller.start();
                  setState(() {});
                },
                onReport: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => BlocProvider.value(
                      value: context.read<BreakBloc>(),
                      child: const BreakReportScreen(),
                    ),
                  ));
                },
              ),
              const Expanded(flex: 2, child: SizedBox()),
              Expanded(
                flex: 5,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  width: 300.0.r,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.blue, width: 4),
                  ),
                  child: _buildQrView(context, widget.homeBloc),
                ),
              ),
              const Expanded(flex: 2, child: SizedBox()),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildQrView(BuildContext context, HomeBloc bloc) {
    return MobileScanner(
      controller: controller,
      onDetect: (event) => _handleBarcode(event, context),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void _handleBarcode(BarcodeCapture event, BuildContext context) {
    if (event.barcodes.isNotEmpty) {
      final barcode = event.barcodes.first;
      if (barcode.rawValue != null && mounted) {
        debugPrint("QR Code: ${barcode.rawValue}");
        context.read<BreakBloc>().add(BreakVerifyQREvent(code: barcode.rawValue!));
        unawaited(controller.stop());
        if (qrFound) {
          qrFound = false;
          Navigator.of(context)
              .push(MaterialPageRoute(
            builder: (_) => BlocProvider.value(
              value: context.read<BreakBloc>(),
              child: BreakBackTypeScreen(homeBloc: widget.homeBloc),
            ),
          ))
              .then((_) {
            ///The easiest way to detect when the screen is popped (returned from navigation)
            /// is to use the .then() method after Navigator.push.
            unawaited(controller.start());
            qrFound = true;
          });
        }
      }
    }
  }
}
