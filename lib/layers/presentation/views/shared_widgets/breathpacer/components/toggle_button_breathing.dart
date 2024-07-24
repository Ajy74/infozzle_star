import 'package:breathpacer/theme/app_theme.dart';
import 'package:flutter/material.dart';

class BreathingToggleButton extends StatelessWidget {
  const BreathingToggleButton({super.key, required this.onToggle, required this.title, required this.isOn});

  final String title;
  final bool isOn;
  final Function() onToggle;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Text(title, style: const TextStyle(fontSize: 16, color: Colors.white)),
      const Spacer(),
      Switch(
          trackColor: isOn ? MaterialStateProperty.all(Colors.white) : MaterialStateProperty.all(Colors.transparent),
          trackOutlineColor: MaterialStateProperty.all(Colors.white),
          thumbColor:
              isOn ? MaterialStateProperty.all(AppTheme.colors.thumbColor) : MaterialStateProperty.all(Colors.white),
          value: isOn,
          onChanged: (_) {
            onToggle();
          })
    ]);
  }
}
