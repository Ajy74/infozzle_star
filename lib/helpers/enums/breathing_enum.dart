import 'package:breathpacer/helpers/images.dart';
import 'package:flutter/cupertino.dart';

enum BreathingIconEnum {
  nothing,
  fire,
  completion,
}

Image iconToImage(BreathingIconEnum icon) {
  switch (icon) {
    case BreathingIconEnum.nothing:
      return Image.asset(Images.noImage, width: 105, height: 105);
    case BreathingIconEnum.fire:
      return Image.asset(Images.fireIcon, width: 105, height: 105);
    case BreathingIconEnum.completion:
      return Image.asset(Images.completionIcon, width: 105, height: 105);
    default:
      return Image.asset(Images.noImage, width: 105, height: 105);
  }
}
