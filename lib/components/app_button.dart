import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final String? text;
  final double size;
  final Function onPressed;

  const AppButton({
    Key? key,
    this.text,
    this.size = 80,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        child: Ink(
          height: size,
          width: size,
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(text ?? '', style: Theme.of(context).textTheme.button),
          ),
        ),
      ),
    );
  }
}
