import 'package:breathpacer/helpers/enums/breathing_enum.dart';
import 'package:breathpacer/layers/presentation/views/shared_widgets/breathpacer/components/drop_down_breathing.dart';
import 'package:breathpacer/layers/presentation/views/shared_widgets/breathpacer/components/pineal_gland_breathing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

import '../../../../../../../helpers/enums/voice_over_enum.dart';
import '../../../../../../domain/models/breathing_exercise_model.dart';
import '../../../../shared_widgets/breathpacer/components/choices_breathing.dart';
import '../../../../shared_widgets/breathpacer/components/pineal_info_breathing.dart';
import '../../../../shared_widgets/breathpacer/components/toggle_button_breathing.dart';
import '../../../../shared_widgets/breathpacer/main_breathing_widget.dart';

class SettingsFireBreathing extends StatelessWidget {
  const SettingsFireBreathing({
    super.key,
    required this.pageController,
    required this.sliderIndex,
    required this.onUpdateSliderIndex,
    required this.onUpdateTimer,
    required this.onUpdateSets,
    required this.onUpdateTimeBetweenSets,
    required this.isMusicOn,
    required this.isChimeOn,
    required this.isJerryOn,
    required this.onToggleMusic,
    required this.onToggleChime,
    required this.onToggleJerry,
    required this.chosenIndex,
    required this.onUpdateChoiceIndex,
    required this.isPinealSelected,
    required this.isInfoSelected,
    required this.onTogglePineal,
    required this.onToggleInfo,
    required this.timeBetweenSets,
    required this.onUpdateVoiceOver,
    required this.numOfSets,
    required this.lengthOfSets,
  });

  final PageController pageController;
  final int sliderIndex;
  final int chosenIndex;
  final bool isMusicOn;
  final bool isChimeOn;
  final bool isJerryOn;
  final bool isPinealSelected;
  final bool isInfoSelected;
  final String timeBetweenSets;
  final String numOfSets;
  final String lengthOfSets;
  final Function(int) onUpdateSliderIndex;
  final Function(int) onUpdateChoiceIndex;
  final Function(String) onUpdateTimer;
  final Function(String) onUpdateSets;
  final Function(String) onUpdateTimeBetweenSets;
  final Function(JerryVoiceEnum) onUpdateVoiceOver;
  final Function() onToggleMusic;
  final Function() onToggleChime;
  final Function() onToggleJerry;
  final Function() onTogglePineal;
  final Function() onToggleInfo;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          MainBreathingWidget(
            pageController: pageController,
            sliderIndex: sliderIndex,
            onUpdateSliderIndex: (int index) {
              onUpdateSliderIndex(index);
            },
            model: const BreathingExerciseModel(
              title: "Fire breathpacer",
              icon: BreathingIconEnum.fire,
              difficulties: ["Beginner", "Experienced"],
              iconDescription: "TYPE 2: Fire breathpacer",
            ),
            onTap: () {},
            onUpdateTimeBetweenSets: (String sets) {
              onUpdateTimeBetweenSets(sets);
            },
            children: [
              BreathingDropDown(
                title: "Length of set:",
                numOfItems: 20,
                initialValue: lengthOfSets,
                identifier: "min",
                onUpdate: (String timer) {
                  onUpdateTimer(timer);
                },
                showHold: false,
              ),
              const SizedBox(height: 16),
              BreathingDropDown(
                title: "Number of sets:",
                numOfItems: 20,
                initialValue: numOfSets,
                identifier: "set",
                onUpdate: (String sets) {
                  onUpdateSets(sets);
                },
                showHold: false,
              ),
              const SizedBox(height: 16),
              BreathingDropDown(
                title: "Seconds between sets  :",
                numOfItems: 20,
                initialValue: timeBetweenSets,
                identifier: "sec",
                onUpdate: (String time) {
                  onUpdateTimeBetweenSets(time);
                },
                showHold: sliderIndex == 1 ? true : false,
              ),
              const SizedBox(height: 16),
              BreathingToggleButton(
                isOn: isJerryOn,
                onToggle: () {
                  onToggleJerry();
                },
                title: "Jerry's voice",
              ),
              const SizedBox(height: 16),
              BreathingGland(
                  isSelected: isPinealSelected,
                  onToggle: (bool isSelected) {
                    onTogglePineal();
                  },
                  isInfoSelected: isInfoSelected,
                  onToggleInfo: () {
                    onToggleInfo();
                  }),
              if (isInfoSelected) const PinealInfoWidget().animate().fadeIn(duration: 500.ms),
              const SizedBox(height: 16),
              BreathingChoices(
                chosenItem: chosenIndex,
                onUpdateChoiceIndex: (int index) {
                  onUpdateChoiceIndex(index);
                },
                onUpdateVoiceOver: (JerryVoiceEnum audio) {
                  onUpdateVoiceOver(audio);
                },
              ),
              const SizedBox(height: 16),
              BreathingToggleButton(
                  isOn: isMusicOn,
                  onToggle: () {
                    onToggleMusic();
                  },
                  title: "Music"),
              const SizedBox(height: 16),
              BreathingToggleButton(
                  isOn: isChimeOn,
                  onToggle: () {
                    onToggleChime();
                  },
                  title: "Chimes at start / stop points"),
            ],
          ),
        ],
      ),
    );
  }
}
