import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class AnimatedTextWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final colorizeColors = [
      Color.fromRGBO(250, 119, 1, 1),
      Color(0xFFF3AA21),
      Color.fromARGB(255, 97, 207, 248),
      Color(0xFF43c7ff),
      Color(0xFF43c7ff),
    ];

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AnimatedTextKit(
            animatedTexts: [
              ColorizeAnimatedText(
                'Dame una mano',
                textStyle: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Monserrat',
                ),
                colors: colorizeColors,
              ),
            ],
            isRepeatingAnimation: true,
            pause: const Duration(milliseconds: 1300),
            displayFullTextOnTap: true,
            stopPauseOnTap: true,
            onTap: () {
              print("Tap Event");
            },
          ),
        ],
      ),
    );
  }
}
