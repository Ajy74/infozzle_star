import 'dart:async';

import 'package:audioplayers/audioplayers.dart';
import 'package:breathpacer/helpers/enums/voice_over_enum.dart';
import 'package:breathpacer/layers/presentation/views/pages/breathpacer/fire_breathing/fire_breathing_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FireBreathingViewModel extends Cubit<FireBreathingState> {
  FireBreathingViewModel() : super(FireBreathingState());
  AudioPlayer musicPlayer = AudioPlayer();
  AudioPlayer chimePlayer = AudioPlayer();
  AudioPlayer jerryPlayer = AudioPlayer();
  AudioPlayer pinealPlayer = AudioPlayer();
  StreamSubscription<void>? jerryPlayerSub;

  // -----------------------------------------------------------------------------
  // Methods for playing Audio in Timer View
  // -----------------------------------------------------------------------------
  Future playMusic() async {
    await musicPlayer.play(AssetSource('audio/music.mp3'));
  }

  Future stopMusic() async {
    await musicPlayer.stop();
  }

  Future playChime() async {
    await chimePlayer.play(AssetSource('audio/bell.mp3'));
  }

  Future resetChime() async {
    await chimePlayer.seek(Duration.zero);
  }

  Future playJerry(JerryVoiceEnum audio) async {
    await jerryPlayer.play(AssetSource(jerryVoiceOver(audio)));

    jerryPlayerSub = jerryPlayer.onPlayerComplete.listen((_) async {
      if (state.isPinealGlandSelected && !state.isRestState) {
        await stopPineal();
        await playPineal();
      }
      if (jerryPlayerSub != null) {
        jerryPlayerSub?.cancel();
      }
    });
  }

  Future stopJerry() async {
    await jerryPlayer.stop();
  }

  void updateJerryAudio(JerryVoiceEnum audio) async {
    state.currentAudio = audio;
    emit(FireBreathingState.clone(state));
  }

  Future playPineal() async {
    await pinealPlayer.setVolume(0.75);
    await pinealPlayer.play(AssetSource('audio/pineal.mp3'));
  }

  Future stopPineal() async {
    await pinealPlayer.stop();
  }

  // -----------------------------------------------------------------------------
  // Functions for Settings View
  // -----------------------------------------------------------------------------

  void toggleIsAudioDone() {
    state.isAudioDone = !state.isAudioDone;
    emit(FireBreathingState.clone(state));
  }

  void toggleIsMusicOn() {
    state.isMusicOn = !state.isMusicOn;
    emit(FireBreathingState.clone(state));
  }

  void toggleIsChimeOn() {
    state.isChimesOn = !state.isChimesOn;
    emit(FireBreathingState.clone(state));
  }

  void toggleIsJerryVoice() {
    state.isJerryVoiceOn = !state.isJerryVoiceOn;
    emit(FireBreathingState.clone(state));
  }

  void toggleIsPinealGlandSelected() {
    state.isPinealGlandSelected = !state.isPinealGlandSelected;
    emit(FireBreathingState.clone(state));
  }

  void toggleIsPinealInfoSelected() {
    state.isPinealInfoSelected = !state.isPinealInfoSelected;
    emit(FireBreathingState.clone(state));
  }

  void toggleIsRest() {
    state.isRestState = !state.isRestState;
    emit(FireBreathingState.clone(state));
  }

  void setSliderIndex(int newIndex) {
    state.sliderIndex = newIndex;
    emit(FireBreathingState.clone(state));
  }

  void setChoiceIndex(int newIndex) {
    state.choiceIndex = newIndex;
    emit(FireBreathingState.clone(state));
  }

  void setCurrentRound(int round) {
    state.currentRound = round;
    emit(FireBreathingState.clone(state));
  }

  void setExerciseTimer(String timer) {
    state.exerciseTimer = timer;
    emit(FireBreathingState.clone(state));
  }

  void setExerciseSets(String sets) {
    state.exerciseSets = sets;
    int totalSetCount = int.parse(sets.split(' ').first);
    state.currentRound = (totalSetCount * 2) - 1;
    emit(FireBreathingState.clone(state));
  }

  void setTimeBetweenSets(String time) {
    state.timeBetweenSets = time;
    emit(FireBreathingState.clone(state));
  }

  void setStartTimer(int time) {
    state.timerStart = time;
    emit(FireBreathingState.clone(state));
  }

  void setEndTimer(int time) {
    state.timerEnd = time;
    emit(FireBreathingState.clone(state));
  }

  void addToCompletionAnalytics(int value) {
    var copyArr = List<int>.from(state.completionAnalytics);
    copyArr.add(value);
    state.completionAnalytics = copyArr;
  }

  // -----------------------------------------------------------------------------
  // Functions for Reset of States
  // -----------------------------------------------------------------------------
  void reset() {
    emit(FireBreathingState());
  }
}
