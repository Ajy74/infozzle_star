import 'package:flutter/material.dart';

class WarningText extends StatelessWidget {
  const WarningText({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisAlignment: MainAxisAlignment.start,
      // Align children to the start (left)
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Before your session", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20, color: Colors.white)),
        SizedBox(height: 20),
        Text("Please sit and lie down in a safe environment.",
            style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16, color: Colors.white)),
        SizedBox(height: 10),
        Text(
            "Don’t practice the breathpacer exercises in a swimming pool, underwater, in the shower, while piloting any on vehicle or without supervision.",
            style: TextStyle(fontWeight: FontWeight.normal, fontSize: 16, color: Colors.white)),
      ],
    );
  }
}
