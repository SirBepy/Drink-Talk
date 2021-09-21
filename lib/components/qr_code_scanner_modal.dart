import 'package:drink_n_talk/components/custom_app_bar.dart';
import 'package:flutter/material.dart';

class QRCodeScannerModal extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      appBar: CustomAppBar(),
      extendBodyBehindAppBar: true,
      body: Center(child: Text('Scanner')),
    );
  }
}
