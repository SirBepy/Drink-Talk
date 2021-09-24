import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final String? text;
  final Icon? icon;
  final double size;
  final VoidCallback onPressed;

  const AppButton({
    Key? key,
    this.text = '',
    this.size = 80,
    required this.onPressed,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(200),
        child: Ink(
          height: size,
          width: size,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: icon ?? Text(text ?? '', style: Theme.of(context).textTheme.button),
          ),
        ),
      ),
    );
  }
}
