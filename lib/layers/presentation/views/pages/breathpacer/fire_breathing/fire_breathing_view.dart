import 'package:breathpacer/layers/presentation/views/pages/breathpacer/fire_breathing/fire_breathing_state.dart';
import 'package:breathpacer/layers/presentation/views/pages/breathpacer/fire_breathing/widgets/begin_fire_breathing.dart';
import 'package:breathpacer/layers/presentation/views/pages/breathpacer/fire_breathing/widgets/completion_fire_breathing.dart';
import 'package:breathpacer/layers/presentation/views/pages/breathpacer/fire_breathing/widgets/settings_fire_breathing.dart';
import 'package:breathpacer/layers/presentation/views/pages/breathpacer/fire_breathing/widgets/timer_fire_breathing.dart';
import 'package:breathpacer/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../helpers/enums/voice_over_enum.dart';
import 'fire_breathing_view_model.dart';

class FireBreathingView extends StatelessWidget {
  FireBreathingView({super.key});

  final FireBreathingViewModel viewModel = FireBreathingViewModel();
  final PageController pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(gradient: AppTheme.colors.linearGradient),
        alignment: Alignment.center,
        child: BlocBuilder<FireBreathingViewModel, FireBreathingState>(
          bloc: viewModel,
          builder: (_, state) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(16, 60, 16, 40),
              child: PageView.builder(
                controller: pageController,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: 4,
                itemBuilder: (_, i) {
                  return [
                    BeginFireBreathing(pageController: pageController),
                    SettingsFireBreathing(
                        pageController: pageController,
                        sliderIndex: state.sliderIndex,
                        chosenIndex: state.choiceIndex,
                        isMusicOn: state.isMusicOn,
                        isChimeOn: state.isChimesOn,
                        isJerryOn: state.isJerryVoiceOn,
                        isInfoSelected: state.isPinealInfoSelected,
                        isPinealSelected: state.isPinealGlandSelected,
                        timeBetweenSets: state.timeBetweenSets,
                        lengthOfSets: state.exerciseTimer,
                        numOfSets: state.exerciseSets,
                        onUpdateSliderIndex: (int index) {
                          viewModel.setSliderIndex(index);
                        },
                        onUpdateChoiceIndex: (int index) {
                          viewModel.setChoiceIndex(index);
                        },
                        onUpdateTimer: (String timer) {
                          viewModel.setExerciseTimer(timer);
                        },
                        onUpdateSets: (String sets) {
                          viewModel.setExerciseSets(sets);
                        },
                        onUpdateTimeBetweenSets: (String time) {
                          viewModel.setTimeBetweenSets(time);
                        },
                        onToggleMusic: () {
                          viewModel.toggleIsMusicOn();
                        },
                        onToggleChime: () {
                          viewModel.toggleIsChimeOn();
                        },
                        onToggleJerry: () {
                          viewModel.toggleIsJerryVoice();
                        },
                        onTogglePineal: () {
                          viewModel.toggleIsPinealGlandSelected();
                        },
                        onToggleInfo: () {
                          viewModel.toggleIsPinealInfoSelected();
                        },
                        onUpdateVoiceOver: (JerryVoiceEnum audio) {
                          viewModel.updateJerryAudio(audio);
                        }),
                    TimerFireBreathing(
                      pageController: pageController,
                      numOfSets: int.tryParse(state.exerciseSets.split(' ').first)!,
                      lengthOfRound: int.tryParse(state.exerciseTimer.split(' ').first)! * 60,
                      lengthOfRest: int.tryParse(state.timeBetweenSets.split(' ').first)!,
                      timerStart: state.timerStart,
                      timerEnd: state.timerEnd,
                      isHold: state.timeBetweenSets == "120 sec" ? true : false,
                      isRest: state.isRestState,
                      isMusicOn: state.isMusicOn,
                      isChimeOn: state.isChimesOn,
                      isJerryOn: state.isJerryVoiceOn,
                      isPineal: state.isPinealGlandSelected,
                      choicesIndex: state.choiceIndex,
                      currentRound: state.currentRound,
                      isAudioDone: state.isAudioDone,
                      currentAudio: state.currentAudio,
                      onUpdateCurrentRound: (int round) {
                        viewModel.setCurrentRound(round);
                      },
                      toggleRest: () {
                        viewModel.toggleIsRest();
                      },
                      onUpdateTimerStart: (int time) {
                        viewModel.setStartTimer(time);
                      },
                      onUpdateTimerEnd: (int time) {
                        viewModel.setEndTimer(time);
                      },
                      onUpdateAnalytics: (int value) {
                        viewModel.addToCompletionAnalytics(value);
                      },
                      toggleAudioDone: () {
                        viewModel.toggleIsAudioDone();
                      },
                      onResetViewModel: () {
                        viewModel.reset();
                      },
                      onUpdateVoiceOver: (JerryVoiceEnum audio) {
                        viewModel.playJerry(audio);
                      },
                      playMusic: () {
                        viewModel.playMusic();
                      },
                      stopMusic: () {
                        viewModel.stopMusic();
                      },
                      playChime: () {
                        viewModel.playChime();
                      },
                      stopChime: () {
                        viewModel.resetChime();
                      },
                      playJerry: () {
                        viewModel.playJerry(state.currentAudio);
                      },
                      stopJerry: () {
                        viewModel.stopJerry();
                      },
                      playPineal: () {
                        viewModel.playPineal();
                      },
                      stopPineal: () {
                        viewModel.stopPineal();
                      },
                    ),
                    CompletionFireBreathing(
                      pageController: pageController,
                      data: state.completionAnalytics,
                      onResetViewModel: () {
                        viewModel.reset();
                      },
                      isHold: state.timeBetweenSets == "120 sec" ? true : false,
                    ),
                  ][i];
                },
              ),
            );
          },
        ),
      ),
    );
  }

  void getTimeFromString() {}
}
