import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({super.key, required this.buttonText, required this.onTap, required this.color});

  final String buttonText;
  final Function() onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            padding: const EdgeInsets.all(15),
            backgroundColor: color),
        onPressed: () {
          onTap();
        },
        child: Container(
          width: double.infinity,
          alignment: Alignment.center,
          child: Text(buttonText,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: color == Colors.white ? Colors.black : Colors.white)),
        ),
      ),
    );
  }
}
