import 'dart:io';

import 'package:drink_n_talk/components/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRCodeScannerModal extends StatefulWidget {
  final BuildContext context;

  const QRCodeScannerModal({required this.context});

  @override
  State<StatefulWidget> createState() => _QRCodeScannerModalState();
}

class _QRCodeScannerModalState extends State<QRCodeScannerModal> {
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  // In order to get hot reload to work properly, we need to pause the camera if the platform
  // is Android, or resume the camera if the platform is iOS.
  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    final scanArea =
        (MediaQuery.of(context).size.width < 400 || MediaQuery.of(context).size.height < 400) ? 150.0 : 300.0;

    return Scaffold(
      body: GestureDetector(
        // Added flip camera functionality in case someone's back camera doesn't work
        onDoubleTap: () async {
          await controller?.flipCamera();
          setState(() {});
        },
        child: Stack(
          children: [
            QRView(
              key: qrKey,
              onQRViewCreated: onQRViewCreated,
              onPermissionSet: (ctrl, p) => onPermissionSet(context, ctrl, p),
              overlay: QrScannerOverlayShape(
                borderColor: Colors.red,
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: scanArea,
              ),
            ),
            // Adding another scaffold since it was the easiest way to reimplement our already working back button
            // Also, you needn't worry, another scaffold doesnt "cost" anything extra in regards to performance
            const Scaffold(
              appBar: CustomAppBar(),
              extendBodyBehindAppBar: true,
              backgroundColor: Colors.transparent,
            ),
          ],
        ),
      ),
    );
  }

  void onQRViewCreated(QRViewController controller) {
    setState(() => this.controller = controller);
    controller.scannedDataStream.listen((Barcode scanData) {
      controller.dispose();
      Navigator.of(widget.context).pop(scanData.code);
    });
  }

  void onPermissionSet(BuildContext context, QRViewController ctrl, bool hasPermissions) {
    if (!hasPermissions) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nije moguće koristiti QR Scanner bez kamere')),
      );
    }
  }
}
