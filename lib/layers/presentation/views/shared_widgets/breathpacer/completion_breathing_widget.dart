import 'package:breathpacer/layers/presentation/views/shared_widgets/breathpacer/components/button_breathing.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../../theme/app_theme.dart';
import '../../../../domain/models/breathing_exercise_model.dart';
import 'components/top_area_breathing.dart';

class CompletionBreathingWidget extends StatelessWidget {
  const CompletionBreathingWidget(
      {super.key,
      required this.pageController,
      required this.model,
      required this.children,
      required this.onResetViewModel});

  final PageController pageController;
  final BreathingExerciseModel model;
  final List<Widget> children;
  final Function() onResetViewModel;

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
          hasBackButton: false,
        ),
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Text("Take a deep breath and relax, regain your normal breathpacer speed. Here are your results",
                  style: TextStyle(fontSize: 16, color: Colors.white)),
              ...children,
              const SizedBox(height: 30),
              restartChallenge(),
              const SizedBox(height: 30),
              BreathingButton(
                pageController: pageController,
                buttonText: "Save  Statistics",
                onTap: () {},
              ),
            ]))
      ],
    );
  }

  Widget restartChallenge() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        color: AppTheme.colors.restartChallengeBg,
        border: Border.all(color: Colors.white38),
      ),
      child: Row(
        children: [
          const Icon(CupertinoIcons.exclamationmark_circle, color: Colors.white, size: 32),
          const SizedBox(width: 16.0),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'You can restart this challenge',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16.0, color: Colors.white),
                ),
                const Text(
                  'Start over and get better results',
                  style: TextStyle(fontSize: 16.0, color: Colors.white),
                ),
                TextButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(EdgeInsets.zero),
                  ),
                  onPressed: () {
                    onResetViewModel();
                    pageController.jumpToPage(1);
                  },
                  child: const Text(
                    'Restart challenge',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 16.0,
                      color: Colors.white,
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
