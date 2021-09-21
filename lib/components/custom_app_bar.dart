import 'package:flutter/material.dart';

// Main purpose of this AppBar is its back button
// The back button UI is different from the default Flutter back button
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final double preferredHeight;

  const CustomAppBar({Key? key, this.preferredHeight = 100}) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(preferredHeight);

  @override
  Widget build(BuildContext context) {
    return PreferredSize(
      preferredSize: preferredSize,
      child: Container(
        padding: const EdgeInsets.only(top: 32, left: 32),
        alignment: Alignment.topLeft,
        child: SafeArea(
          child: InkWell(
            onTap: () => Navigator.of(context).pop(),
            borderRadius: BorderRadius.circular(200),
            child: Ink(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Theme.of(context).backgroundColor,
                borderRadius: BorderRadius.circular(200),
              ),
              child: const Icon(
                Icons.chevron_left_rounded,
                color: Colors.black,
                size: 32,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
