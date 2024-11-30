import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:onote/main.dart';
// import 'package:onote/widget/easy_button.dart';
import 'package:onote/widget/onote_scaffold.dart';
// import 'package:mobile_scanner/mobile_scanner.dart';

class QrScanController extends GetxController {

  // MobileScannerController scannerController = MobileScannerController(
  //   detectionSpeed: DetectionSpeed.normal,
  //   facing: CameraFacing.back,
  //   torchEnabled: false
  // );
}

class QrScanPlugin extends GetView<QrScanController> {

  const QrScanPlugin({super.key});

  @override
  QrScanController get controller => Get.put(QrScanController());

  static Logger logger = Logger();

  @override
  Widget build(BuildContext context) {

    // final arguments = Get.arguments as Map;

    return ONoteScaffold(
      appBar: const ONoteAppBar(
        backColor: Colors.white70,
        closeIconData: Icons.close_outlined,
        // title: EasyButton.custom(iconData:Icons.qr_code_scanner, iconColor: Colors.white70),
        // backgroundColor: const Color(0XAA000000)
        actions: [
          // ValueListenableBuilder(
          //     valueListenable: controller.scannerController,
          //     builder: (context, state, child) {
          //       if (!state.isInitialized || !state.isRunning) {
          //         return const SizedBox.shrink();
          //       }
          //       return EasyButton.custom(
          //         iconData: state.torchState==TorchState.on ? Icons.flash_on : Icons.flash_off,
          //         iconColor: Colors.white70,
          //         width: 50,
          //         onPressed: () {
          //           if (state.isInitialized && state.isRunning) {
          //             controller.scannerController.toggleTorch();
          //           }
          //         }
          //       );
          //     }
          // )
        ],
      ),
      // fixBody: MobileScanner(
      //   controller: controller.scannerController,
      //   onDetect: (capture) {
      //     final List<Barcode> barcodes = capture.barcodes;
      //     // final Uint8List? image = capture.image;
      //     for (final barcode in barcodes) {
      //       if (barcode.rawValue!=null && barcode.rawValue!.startsWith(arguments["startsWith"])) {
      //         Get.back(
      //           result: {"qr_code": barcode.rawValue!},
      //           closeOverlays: false
      //         );
      //         // debugPrint("zzz");
      //         // Get.back();
      //       }
      //     }
      //   },
      // ),
      afterBodyPositionedList: [
        Positioned(
          top: ui.windowHeight / 2 - ui.windowWidth / 4,
          child: Container(
            width: ui.windowWidth / 1.8,
            height: ui.windowWidth / 1.8,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white38, width: 4),
              borderRadius: BorderRadius.circular(30)
            ),
          )
        )
      ],
    );
  }
}