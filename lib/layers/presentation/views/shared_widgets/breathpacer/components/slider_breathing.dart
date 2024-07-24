import 'package:breathpacer/theme/app_theme.dart';
import 'package:custom_sliding_segmented_control/custom_sliding_segmented_control.dart';
import 'package:flutter/material.dart';

class SliderBreathing extends StatelessWidget {
  const SliderBreathing(
      {super.key,
      required this.segments,
      required this.sliderIndex,
      required this.onUpdateSliderIndex,
      required this.onUpdateTimeBetweenSets});

  final List<String> segments;
  final int sliderIndex;
  final Function(int) onUpdateSliderIndex;
  final Function(String) onUpdateTimeBetweenSets;

  @override
  Widget build(BuildContext context) {
    return CustomSlidingSegmentedControl<int>(
      initialValue: sliderIndex,
      isStretch: true,
      children: {
        for (var index in segments.asMap().keys)
          index: Text(segments[index],
              style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 16,
                  color: index == sliderIndex ? Colors.white : AppTheme.colors.blueSlider))
      },
      decoration: BoxDecoration(
        border: const Border(
          top: BorderSide(
            color: Colors.white, // Horizontal border color
            width: 6.0, // Horizontal border width
          ),
          bottom: BorderSide(
            color: Colors.white, // Horizontal border color
            width: 6.0, // Horizontal border width
          ),
          left: BorderSide(
            color: Colors.white, // Vertical border color
            width: 10.0, // Vertical border width
          ),
          right: BorderSide(
            color: Colors.white, // Vertical border color
            width: 10.0, // Vertical border width
          ),
        ),
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      thumbDecoration: BoxDecoration(
        color: AppTheme.colors.blueSlider,
        borderRadius: BorderRadius.circular(6),
        boxShadow: [
          BoxShadow(
            color: AppTheme.colors.blueSlider.withOpacity(.3),
            blurRadius: 4.0,
            spreadRadius: 1.0,
            offset: const Offset(
              0.0,
              2.0,
            ),
          ),
        ],
      ),
      duration: const Duration(milliseconds: 100),
      curve: Curves.easeIn,
      onValueChanged: (tabValue) {
        onUpdateSliderIndex(tabValue);
        onUpdateTimeBetweenSets(tabValue == 0 ? "3 sec" : "120 sec");
      },
    );
  }
}
