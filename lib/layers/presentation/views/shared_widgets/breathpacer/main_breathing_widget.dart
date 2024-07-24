import 'package:breathpacer/layers/presentation/views/shared_widgets/breathpacer/components/button_breathing.dart';
import 'package:flutter/material.dart';

import '../../../../domain/models/breathing_exercise_model.dart';
import 'components/slider_breathing.dart';
import 'components/top_area_breathing.dart';

class MainBreathingWidget extends StatelessWidget {
  const MainBreathingWidget(
      {super.key,
      required this.pageController,
      required this.sliderIndex,
      required this.onUpdateSliderIndex,
      required this.model,
      required this.children,
      required this.onTap,
      required this.onUpdateTimeBetweenSets});

  final PageController pageController;
  final BreathingExerciseModel model;
  final List<Widget> children;
  final int sliderIndex;
  final Function(int) onUpdateSliderIndex;
  final Function(String) onUpdateTimeBetweenSets;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TopArea(
          onBackButtonPressed: () {
            pageController.previousPage(duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
          },
          title: model.title,
          hasIcon: true,
          iconTitle: model.iconDescription,
          iconEnum: model.icon,
          hasBackButton: true,
        ),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SliderBreathing(
                segments: model.difficulties,
                sliderIndex: sliderIndex,
                onUpdateSliderIndex: (int index) {
                  onUpdateSliderIndex(index);
                },
                onUpdateTimeBetweenSets: (String sets) {
                  onUpdateTimeBetweenSets(sets);
                },
              ),
              const SizedBox(height: 20),
              ...children,
              const SizedBox(height: 40),
              BreathingButton(onTap: onTap, pageController: pageController, buttonText: "Start"),
            ]))
      ],
    );
  }
}
