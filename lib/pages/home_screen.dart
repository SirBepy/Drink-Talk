import 'package:drink_n_talk/components/app_button.dart';
import 'package:drink_n_talk/components/custom_app_bar.dart';
import 'package:drink_n_talk/components/qr_code_scanner_modal.dart';
import 'package:drink_n_talk/utils/spacers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isOpen = false;
  double verticalDrag = 0;

  void onCreate() {
    // TODO: Add firebase logic
  }

  Future<void> showQRCodeReader() async {
    if (isOpen) return;
    setState(() => isOpen = true);
    await showMaterialModalBottomSheet(
      context: context,
      builder: (context) => QRCodeScannerModal(),
    );
    setState(() => isOpen = false);
  }

  void onVerticalDragUpdate(DragUpdateDetails details) {
    verticalDrag += details.localPosition.dy;
    if (verticalDrag < -500) {
      showQRCodeReader();
      verticalDrag = 0;
    }
    print(verticalDrag);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      extendBodyBehindAppBar: true,
      body: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Hero(
                  tag: 'logo',
                  child: SvgPicture.asset(
                    'assets/images/logo.svg',
                    width: 180,
                  ),
                ),
                Spacers.h32,
                Spacers.h8,
                Text('Hellou', style: Theme.of(context).textTheme.headline1),
                Text(
                  'Predrag',
                  style: Theme.of(context).textTheme.headline1!.copyWith(color: Theme.of(context).primaryColor),
                ),
                Spacers.h64,
                AppButton(
                  text: 'Kreiraj Igru',
                  size: 180,
                  onPressed: onCreate,
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => showQRCodeReader(),
            onVerticalDragUpdate: onVerticalDragUpdate,
            onVerticalDragEnd: (_) => verticalDrag = 0,
            child: Container(
              width: double.infinity,
              height: 100,
              decoration: BoxDecoration(
                color: Theme.of(context).backgroundColor,
                borderRadius: BorderRadius.circular(200),
              ),
              child: Center(
                child: Text(
                  'Prijavi se u postojeću igru',
                  style: Theme.of(context).textTheme.headline3!.copyWith(color: Theme.of(context).primaryColor),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
