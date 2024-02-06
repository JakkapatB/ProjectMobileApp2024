import 'package:flutter/material.dart';

class LabelText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color fontColor;
  final FontWeight fontWeight;

  const LabelText({
    super.key,
    required this.text,
    required this.fontSize,
    required this.fontColor,
    this.fontWeight = FontWeight.normal,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: fontWeight,
        color: fontColor,
      ),
    );
  }
}
