import 'package:flutter/material.dart';
import 'package:outline_gradient_button/outline_gradient_button.dart';

class CustomLinearButton extends StatelessWidget {
  const CustomLinearButton(
      {super.key, required this.buttonText, required this.onTap, required this.color, required this.gradient});

  final String buttonText;
  final Function() onTap;
  final Color color;
  final LinearGradient gradient;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: OutlineGradientButton(
        gradient: gradient,
        strokeWidth: 2,
        backgroundColor: color,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 17),
        radius: const Radius.circular(60),
        onTap: () {
          onTap();
        },
        child: Center(
            child: Text(buttonText,
                style: TextStyle(
                    color: color == Colors.white ? Colors.black : Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold))),
      ),
    );
  }
}
