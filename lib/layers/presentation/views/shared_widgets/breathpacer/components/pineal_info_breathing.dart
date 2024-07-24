import 'dart:math';

import 'package:breathpacer/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';

class PinealInfoWidget extends StatelessWidget {
  const PinealInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: MediaQuery.of(context).size.width / 4),
            child: Transform.rotate(
              angle: pi,
              child: ClipPath(
                clipper: TriangleClipper(),
                child: Container(
                  width: 37,
                  height: 20,
                  decoration: BoxDecoration(color: AppTheme.colors.bluePineal),
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
                gradient: AppTheme.colors.linearGradient,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(20))),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 25),
            child: const Row(
              children: [
                Icon(Icons.info_outline_rounded, color: Colors.white, size: 30),
                SizedBox(width: 10),
                Text(
                  "Pineal Gland",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: const BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.vertical(bottom: Radius.circular(20))),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 25),
            child: const Row(
              children: [
                Expanded(
                  // Added Expanded widget here
                  child: Text(
                    "This is the squeeze and hold of your buttocks and genitals, tip of the tongue on the roof of the mouth",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                      fontSize: 16,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
