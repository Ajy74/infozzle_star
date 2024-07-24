import 'package:breathpacer/theme/app_theme.dart';
import 'package:flutter/material.dart';

class BreathingGland extends StatelessWidget {
  const BreathingGland({
    super.key,
    required this.isSelected,
    required this.onToggle,
    required this.isInfoSelected,
    required this.onToggleInfo,
  });

  final bool isSelected;
  final Function(bool) onToggle;
  final bool isInfoSelected;
  final Function() onToggleInfo;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      const SizedBox(width: 10),
      const Text(
        "Pineal Gland",
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
      IconButton(
        onPressed: () {
          onToggleInfo();
        },
        icon: const Icon(
          Icons.info_outline_rounded,
          color: Colors.white,
          size: 20,
        ),
      ),
      const Spacer(),
      ElevatedButton(
        style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(3.0), side: const BorderSide(color: Colors.white))),
            backgroundColor: isSelected
                ? MaterialStateProperty.all(Colors.white)
                : MaterialStateProperty.all(AppTheme.colors.blueSlider)),
        onPressed: () {
          onToggle(!isSelected);
        },
        child: Text(
          isSelected ? 'Yes' : 'No',
          style: TextStyle(color: isSelected ? Colors.black : Colors.white, fontSize: 14),
        ),
      )
    ]);
  }
}
