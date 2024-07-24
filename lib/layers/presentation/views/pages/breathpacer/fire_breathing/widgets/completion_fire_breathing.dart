import 'package:breathpacer/helpers/enums/breathing_enum.dart';
import 'package:breathpacer/layers/presentation/views/shared_widgets/breathpacer/completion_breathing_widget.dart';
import 'package:flutter/material.dart';

import '../../../../../../domain/models/breathing_exercise_model.dart';
import '../../../../shared_widgets/breathpacer/components/completion_analytics_breathing.dart';

class CompletionFireBreathing extends StatelessWidget {
  const CompletionFireBreathing({
    super.key,
    required this.pageController,
    required this.data,
    required this.onResetViewModel,
    required this.isHold,
  });

  final PageController pageController;
  final List<int> data;
  final bool isHold;
  final Function() onResetViewModel;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          CompletionBreathingWidget(
              pageController: pageController,
              model: const BreathingExerciseModel(
                title: "Fire breathpacer",
                icon: BreathingIconEnum.completion,
                difficulties: [],
                iconDescription: "Well Done!",
              ),
              onResetViewModel: () {
                onResetViewModel();
              },
              children: [
                const SizedBox(height: 30),
                BreathingCompletionAnalytics(
                    title: 'Session Average',
                    averageTime: calculateAverageTime(data, true),
                    identifier: 'Length',
                    entries: convertTimeToFormat(data, true)),
                const SizedBox(height: 30),
                if (data.length > 1 && isHold)
                  BreathingCompletionAnalytics(
                      title: 'Hold Period Average',
                      averageTime: calculateAverageTime(data, false),
                      identifier: 'Period',
                      entries: convertTimeToFormat(data, false)),
              ]),
        ],
      ),
    );
  }

  Map<int, String> convertTimeToFormat(List<int> timeList, bool isEven) {
    Map<int, String> resultMap = {};
    int index = 1;

    for (int i = isEven ? 0 : 1; i < timeList.length; i += 2) {
      int seconds = timeList[i];
      int minutes = seconds ~/ 60;
      int remainingSeconds = seconds % 60;
      String formattedTime = '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
      resultMap[index++] = formattedTime;
    }

    return resultMap;
  }

  String calculateAverageTime(List<int> timeList, bool isEven) {
    List<int> filteredList = [];

    for (int i = isEven ? 0 : 1; i < timeList.length; i += 2) {
      filteredList.add(timeList[i]);
    }

    if (filteredList.isEmpty) {
      return '';
    }

    int totalSeconds = filteredList.reduce((value, element) => value + element);
    int averageSeconds = totalSeconds ~/ filteredList.length;
    int minutes = averageSeconds ~/ 60;
    int remainingSeconds = averageSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
