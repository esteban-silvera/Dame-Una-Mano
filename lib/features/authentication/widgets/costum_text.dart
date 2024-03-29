import 'package:flutter/material.dart';

class CustomText extends StatelessWidget {
  final String text;
  final Color color;
  final double fontSize;
  final FontWeight fontWeight;
  final TextAlign alignment;

  const CustomText({
    Key? key,
    required this.text,
    this.color = Colors.black,
    this.fontSize = 16.0,
    this.fontWeight = FontWeight.normal,
    this.alignment = TextAlign.left
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight,
      ),
      textAlign: alignment,
    );
  }
}




class CustomTextWithVisibility extends StatelessWidget {
  final String text;
  final Color color;
  final double fontSize;
  final bool isVisible;
  

  const CustomTextWithVisibility({
    Key? key,
    required this.text,
    required this.color,
    required this.fontSize,
    required this.isVisible,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isVisible,
      child: CustomText(
        text: text,
        color: color,
        fontSize: fontSize,
      ),
    );
  }
}