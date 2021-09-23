import 'package:drink_n_talk/components/app_button.dart';
import 'package:drink_n_talk/components/bottom_button.dart';
import 'package:drink_n_talk/components/custom_app_bar.dart';
import 'package:drink_n_talk/components/qr_code_scanner_modal.dart';
import 'package:drink_n_talk/models/room.dart';
import 'package:drink_n_talk/pages/countdown_screen.dart';
import 'package:drink_n_talk/pages/setup_screen.dart';
import 'package:drink_n_talk/services/room_service.dart';
import 'package:drink_n_talk/utils/spacers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isOpen = false;
  String username = '';

  @override
  void initState() {
    super.initState();
    RoomService.deleteOldData();
    loadUsername();
  }

  Future<void> loadUsername() async {
    final sharedPrefs = await SharedPreferences.getInstance();
    setState(() => username = sharedPrefs.getString('username') ?? 'Korisnik');
  }

  void onCreate() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const SetupScreen()),
    );
  }

  Future<void> showQRCodeReader() async {
    //? Doing this to make sure the user cant open two QRCodeScannerModals at the same time
    if (isOpen) return;
    setState(() => isOpen = true);
    final response = await showMaterialModalBottomSheet(
      context: context,
      builder: (context) => QRCodeScannerModal(context: context),
    );
    if (response != null) {
      handleQRCodeResponse(response);
    }
    setState(() => isOpen = false);
  }

  Future<void> handleQRCodeResponse(dynamic response) async {
    if (response is! String || response.isEmpty) {
      return showErrorToast('QR Kod je neispravan');
    }
    final Room? room = await RoomService.getRoom(response);
    if (room == null) {
      return showErrorToast('Ova Drink&Talk soba ne postoji');
    }

    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const CountdownScreen()),
    );
  }

  void showErrorToast(String text) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));
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
                  '$username',
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
          BottomButton(
            onPressed: showQRCodeReader,
            text: 'Prijavi se u postojeću igru',
          )
        ],
      ),
    );
  }
}
