import 'package:flutter/material.dart';

class BottomButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String text;
  final bool isDark;

  const BottomButton({
    Key? key,
    this.onPressed,
    required this.text,
    this.isDark = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: const BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50)),
      child: Ink(
        width: double.infinity,
        height: 100,
        decoration: BoxDecoration(
          color: isDark ? Theme.of(context).primaryColor : Theme.of(context).backgroundColor,
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50)),
        ),
        child: Center(
          child: Text(
            text,
            style: Theme.of(context).textTheme.headline3!.copyWith(
                  color: isDark ? Theme.of(context).backgroundColor : Theme.of(context).primaryColor,
                ),
          ),
        ),
      ),
    );
  }
}
