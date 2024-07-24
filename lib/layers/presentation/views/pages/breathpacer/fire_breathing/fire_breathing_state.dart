import 'package:breathpacer/helpers/enums/voice_over_enum.dart';

class FireBreathingState {
  bool isChimesOn;
  bool isMusicOn;
  bool isJerryVoiceOn;
  bool isPinealGlandSelected;
  bool isPinealInfoSelected;
  bool isRestState;
  bool isAudioDone;
  int currentRound;
  int sliderIndex;
  int choiceIndex;
  int timerStart;
  int timerEnd;
  String exerciseTimer;
  String exerciseSets;
  String timeBetweenSets;
  JerryVoiceEnum currentAudio;
  List<int> completionAnalytics;

  FireBreathingState({
    this.isChimesOn = false,
    this.isMusicOn = false,
    this.isJerryVoiceOn = false,
    this.isPinealGlandSelected = false,
    this.isPinealInfoSelected = false,
    this.isRestState = false,
    this.isAudioDone = false,
    this.currentRound = 1,
    this.sliderIndex = 0,
    this.choiceIndex = 0,
    this.timerStart = 0,
    this.timerEnd = 0,
    this.exerciseTimer = "1 min",
    this.exerciseSets = "1 set",
    this.timeBetweenSets = "3 sec",
    this.currentAudio = JerryVoiceEnum.breatheIn,
    this.completionAnalytics = const [],
  });

  FireBreathingState.clone(FireBreathingState existingState)
      : this(
          isChimesOn: existingState.isChimesOn,
          isMusicOn: existingState.isMusicOn,
          isJerryVoiceOn: existingState.isJerryVoiceOn,
          isPinealGlandSelected: existingState.isPinealGlandSelected,
          isPinealInfoSelected: existingState.isPinealInfoSelected,
          isRestState: existingState.isRestState,
          isAudioDone: existingState.isAudioDone,
          currentRound: existingState.currentRound,
          sliderIndex: existingState.sliderIndex,
          choiceIndex: existingState.choiceIndex,
          timerStart: existingState.timerStart,
          timerEnd: existingState.timerEnd,
          exerciseTimer: existingState.exerciseTimer,
          exerciseSets: existingState.exerciseSets,
          timeBetweenSets: existingState.timeBetweenSets,
          currentAudio: existingState.currentAudio,
          completionAnalytics: existingState.completionAnalytics,
        );
}
