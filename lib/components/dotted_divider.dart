import 'package:flutter/material.dart';

class DottedDivider extends StatelessWidget {
  final double height;

  const DottedDivider({this.height = 1});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        const dashWidth = 10.0;

        final boxWidth = constraints.constrainWidth();
        final dashHeight = height;
        final dashCount = (boxWidth / (2 * dashWidth)).floor();
        final decoratedBox = DecoratedBox(decoration: BoxDecoration(color: Theme.of(context).dividerColor));

        final dash = SizedBox(
          width: dashWidth,
          height: dashHeight,
          child: decoratedBox,
        );

        return Flex(
          children: [
            // This SizedBox and the other one is only added because in the design, the dotted line starts and ends on half a dash
            SizedBox(
              width: dashWidth / 2,
              height: dashHeight,
              child: decoratedBox,
            ),
            ...List.generate(dashCount, (_) => dash),
            // This is the "other" SizedBox
            SizedBox(
              width: dashWidth / 2,
              height: dashHeight,
              child: decoratedBox,
            ),
          ],
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: Axis.horizontal,
        );
      },
    );
  }
}
