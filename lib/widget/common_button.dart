import 'package:flutter/material.dart';

import '../constants.dart';
import 'app_text.dart';


class CommonButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final double? width;
  final Color color;
  final double? height;
  final double? radius;

  final Color? textColor;

  const CommonButton(
      {super.key,
      required this.text,
      required this.onTap,
      this.width,
      this.height,
      required this.color,
      this.textColor,
      this.radius});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        // width: width,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(defPadding / 2),
        ),
        child: Center(
            child: AppText(
          text: text,
          clr: textColor,
          fontWeight: FontWeight.bold,
        )
            // Text(
            //   text,
            //   style: TextStyle(
            //     color: textColor,
            //     fontWeight: FontWeight.bold,
            //   ),
            // ),
            ),
      ),
    );
  }
}
