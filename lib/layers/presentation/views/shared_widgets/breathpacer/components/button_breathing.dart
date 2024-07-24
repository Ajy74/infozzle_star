import 'package:flutter/material.dart';

import '../../../../../../theme/app_theme.dart';

class BreathingButton extends StatelessWidget {
  const BreathingButton({super.key, required this.pageController, required this.buttonText, required this.onTap});

  final PageController pageController;
  final String buttonText;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(15),
                  backgroundColor: AppTheme.colors.pinkButton),
              onPressed: () {
                onTap();
                pageController.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
              },
              child: Text(buttonText,
                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 20, color: Colors.white))))
    ]);
  }
}
