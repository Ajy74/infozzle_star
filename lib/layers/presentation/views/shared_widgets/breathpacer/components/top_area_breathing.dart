import 'package:flutter/material.dart';

import '../../../../../../helpers/enums/breathing_enum.dart';
import '../../../../../../helpers/images.dart';

class TopArea extends StatelessWidget {
  const TopArea(
      {super.key,
      required this.onBackButtonPressed,
      required this.title,
      required this.hasIcon,
      required this.iconTitle,
      required this.iconEnum,
      required this.hasBackButton});

  final VoidCallback onBackButtonPressed;
  final String title;
  final bool hasIcon;
  final bool hasBackButton;
  final String iconTitle;
  final BreathingIconEnum iconEnum;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(alignment: AlignmentDirectional.center, children: [
          const SizedBox(
            width: double.infinity,
          ),
          if (hasBackButton)
            Positioned(
                right: MediaQuery.of(context).size.width / 1.22,
                child: IconButton(
                  icon: Image.asset(
                    Images.backButton,
                    width: 24,
                    height: 24,
                  ),
                  onPressed: onBackButtonPressed,
                )),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 20, color: Colors.white)),
        ]),
        Divider(color: Colors.white.withOpacity(0.3)),
        if (hasIcon) icon()
      ],
    );
  }

  Widget icon() {
    return Column(children: [
      const SizedBox(height: 45),
      iconToImage(iconEnum),
      const SizedBox(height: 26),
      Text(iconTitle, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 20, color: Colors.white)),
      const SizedBox(height: 30)
    ]);
  }
}
