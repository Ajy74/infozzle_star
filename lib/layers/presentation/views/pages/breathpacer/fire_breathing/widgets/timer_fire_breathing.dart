import 'dart:async';

import 'package:breathpacer/helpers/enums/breathing_enum.dart';
import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../../../../../helpers/enums/voice_over_enum.dart';
import '../../../../../../../theme/app_theme.dart';
import '../../../../shared_widgets/breathpacer/components/top_area_breathing.dart';

//ignore: must_be_immutable
class TimerFireBreathing extends HookWidget {
  TimerFireBreathing({
    super.key,
    required this.pageController,
    required this.numOfSets,
    required this.lengthOfRound,
    required this.lengthOfRest,
    required this.isHold,
    required this.isRest,
    required this.isMusicOn,
    required this.isChimeOn,
    required this.isJerryOn,
    required this.isPineal,
    required this.currentRound,
    required this.onUpdateCurrentRound,
    required this.toggleRest,
    required this.timerStart,
    required this.timerEnd,
    required this.choicesIndex,
    required this.onUpdateTimerStart,
    required this.onUpdateTimerEnd,
    required this.onUpdateAnalytics,
    required this.isAudioDone,
    required this.toggleAudioDone,
    required this.onResetViewModel,
    required this.onUpdateVoiceOver,
    required this.currentAudio,
    required this.playMusic,
    required this.stopMusic,
    required this.playChime,
    required this.stopChime,
    required this.playJerry,
    required this.stopJerry,
    required this.playPineal,
    required this.stopPineal,
  });

  final PageController pageController;
  final int numOfSets;
  final int lengthOfRound;
  final int lengthOfRest;
  final bool isHold;
  final bool isRest;
  final bool isAudioDone;
  final bool isMusicOn;
  final bool isChimeOn;
  final bool isJerryOn;
  final bool isPineal;
  final int currentRound;
  final int timerStart;
  final int timerEnd;
  final int choicesIndex;
  final Function(int) onUpdateCurrentRound;
  final Function(int) onUpdateTimerStart;
  final Function(int) onUpdateTimerEnd;
  final Function(int) onUpdateAnalytics;
  final Function(JerryVoiceEnum audio) onUpdateVoiceOver;
  final Function() onResetViewModel;
  final Function() toggleAudioDone;
  final Function() toggleRest;
  final CountDownController countDownController = CountDownController();

  final Function() playMusic;
  final Function() stopMusic;
  final Function() playChime;
  final Function() stopChime;
  final Function() playJerry;
  final Function() stopJerry;
  final Function() playPineal;
  final Function() stopPineal;

  final JerryVoiceEnum currentAudio;

  StreamSubscription<void>? jerryPlayerSub;

  @override
  Widget build(BuildContext context) {
    int numberOfRounds = (numOfSets * 2) - 1;
    String currentState = "";
    String doubleTapText = "";
    String currentInstruction = "";

    // -----------------------------------------------------------------------------
    // Setting current instructions
    // -----------------------------------------------------------------------------
    if (choicesIndex == 0 && !isPineal && !isRest) {
      currentInstruction = "Breathe in rapidly";
    } else if (choicesIndex == 1 && !isPineal && !isRest) {
      currentInstruction = "Breathe out rapidly";
    } else if (choicesIndex == 2 && !isPineal && !isRest) {
      currentInstruction = "Breathe in rapidly, Breathe out rapidly";
    } else if (isPineal && !isRest) {
      currentInstruction = "Focus on activating your pineal gland";
    }

    // -----------------------------------------------------------------------------
    // Setting currentState and doubleTapText
    // -----------------------------------------------------------------------------

    if (isRest && !isHold && currentRound - 1 <= 0) {
      currentState = "Rest Time";
      doubleTapText = "Tap twice to go to next set";
    } else if (isHold && isRest) {
      currentState = "Hold";
      doubleTapText = "Tap twice to go to next set";
    } else if (isHold && !isRest) {
      currentState = "Fire Breathing";
      doubleTapText = "Tap twice to hold";
    } else {
      currentState = "Fire Breathing";
      doubleTapText = "Tap twice to take rest";
    }

    // -----------------------------------------------------------------------------
    // Use Effects
    // -----------------------------------------------------------------------------

    useEffect(() {
      void run() async {
        if (isHold && isRest) {
          onUpdateVoiceOver(JerryVoiceEnum.hold);
          await stopMusic();
          await stopPineal();
        } else if (isRest && !isHold) {
          await stopMusic();
          await stopJerry();
          await stopPineal();
        } else {
          if (isMusicOn) {
            await playMusic();
          }
          onUpdateVoiceOver(currentAudio);
        }
      }

      run();
      return null;
    }, [isRest, isHold]);

    useEffect(
      () {
        void playAudio() async {
          if (isChimeOn) {
            await stopChime();
            await playChime();
          }
        }

        playAudio();
        var time = DateTime.now().millisecondsSinceEpoch;
        onUpdateTimerStart(time);
        return null;
      },
      [currentRound],
    );

    // -----------------------------------------------------------------------------
    // UI
    // -----------------------------------------------------------------------------

    return Column(children: [
      TopArea(
        onBackButtonPressed: () {
          void run() async {
            await stopMusic();
            await stopJerry();
            await stopPineal();
          }

          run();
          onResetViewModel();
          pageController.previousPage(duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
        },
        title: "Fire breathpacer",
        hasIcon: false,
        iconTitle: "",
        iconEnum: BreathingIconEnum.nothing,
        hasBackButton: true,
      ),
      const SizedBox(height: 70),
      Text(currentState, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 25, color: Colors.white)),
      const SizedBox(height: 10),
      Text(currentInstruction, style: const TextStyle(fontWeight: FontWeight.w400, fontSize: 15, color: Colors.white)),
      const SizedBox(height: 50),
      Stack(
        alignment: AlignmentDirectional.center,
        children: [
          if (!isRest)
            Positioned(
                top: MediaQuery.of(context).size.height * 0.12,
                child: Text("Round ${((numberOfRounds - currentRound) ~/ 2) + 1}",
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: Colors.white))),
          CircularCountDownTimer(
              key: Key(isRest.toString() + currentRound.toString()),
              onComplete: () {
                toggleCurrentRound();
              },
              controller: countDownController,
              width: MediaQuery.of(context).size.width / 2,
              height: MediaQuery.of(context).size.height / 3,
              duration: isRest ? lengthOfRest : lengthOfRound,
              autoStart: currentRound > 0,
              isReverse: isHold && isRest ? false : true,
              strokeCap: StrokeCap.round,
              textStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 30, color: Colors.white),
              strokeWidth: 15.0,
              fillColor: Colors.white,
              ringColor: AppTheme.colors.blueSlider)
        ],
      ),
      Expanded(
        child: GestureDetector(
          onDoubleTap: () {
            toggleCurrentRound();
          },
          child: Container(
            color: Colors.transparent,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  doubleTapText,
                  style: const TextStyle(color: Colors.white, fontSize: 15),
                ),
                const SizedBox(width: 10),
                const Icon(Icons.touch_app_outlined, size: 25, color: Colors.white),
              ],
            ),
          ),
        ),
      ),
    ]);
  }

  // -----------------------------------------------------------------------------
  // Helper Functions
  // -----------------------------------------------------------------------------
  void toggleCurrentRound() async {
    var time = DateTime.now().millisecondsSinceEpoch;
    var finalTime = calculateTimeDifference(timerStart, time);
    var remainingSets = currentRound - 1;

    toggleRest();
    onUpdateTimerEnd(time);
    onUpdateCurrentRound(remainingSets);
    onUpdateAnalytics(finalTime);

    if (remainingSets <= 0) {
      toggleAudioDone();
      stopJerry();
      stopMusic();
      stopPineal();
      pageController.nextPage(duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
    }
  }

  int calculateTimeDifference(int time1, int time2) {
    int differenceInSeconds = ((time2 - time1) / 1000).round();
    return differenceInSeconds;
  }
}
