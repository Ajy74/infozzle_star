import 'dart:math';

import 'package:breathpacer/layers/domain/use_cases/database/add_audio_to_playlist_use_case.dart';
import 'package:breathpacer/layers/domain/use_cases/database/remove_audio_from_playlists_use_case.dart';
import 'package:breathpacer/layers/presentation/download_manager/download_helper.dart';
import 'package:breathpacer/layers/presentation/views/pages/audio_player/audio_player_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:toastification/toastification.dart';

import '../../../../core/globals.dart';
import '../../../../domain/models/light_language_audio.dart';
import '../../../../domain/models/playlist_model.dart';
import '../../../../domain/use_cases/database/get_user_playlists_simple_use_case.dart';

class AudioPlayerViewModel extends Cubit<AudioPlayerState> with ChangeNotifier {
  AudioPlayerViewModel() : super(AudioPlayerState()) {
    getPlaylists();
    audioPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        playNextAudio();
      }
    });
  }

  final SearchController controller = SearchController();
  final dio = Dio();
  final audioPlayer = AudioPlayer();
  AddAudioToPlaylistUseCase addAudioToPlaylistUseCase = AddAudioToPlaylistUseCase();
  RemoveAudioFromPlaylistUseCase removeAudioFromPlaylistUseCase = RemoveAudioFromPlaylistUseCase();
  GetUserPlaylistsSimpleUseCase getUserPlaylistsSimpleUseCase = GetUserPlaylistsSimpleUseCase();

  void populateAudioList(List<LightLanguageAudioModel> audios) {
    state.allAudioList = audios;
    getPlaylistsContainingAudio(state.allAudioList[state.currentAudioIndex].id);
    emit(AudioPlayerState.clone(state));
  }

  void updateIsDownloaded(bool value) {
    state.isDownloaded = value;
    emit(AudioPlayerState.clone(state));
  }

  void setAudioPlayer(String url, bool autoPlay) async {
    state.isLoading = true;
    state.isLoadingFavouriteAndDownload = true;
    emit(AudioPlayerState.clone(state));

    String? downloadedPath = await DownloadHelper.getDownloadedPath(state.isShuffleOn
        ? state.shuffledAudioList[state.currentAudioIndex].id
        : state.allAudioList[state.currentAudioIndex].id);

    bool isDownloaded = downloadedPath != null;

    if (isDownloaded) {
      await audioPlayer.setFilePath(downloadedPath);
    } else {
      await audioPlayer.setUrl(url);
    }

    audioPlayer.playerStateStream.listen((audioState) {
      switch (audioState.processingState) {
        case ProcessingState.idle:
        case ProcessingState.loading:
        case ProcessingState.buffering:
        case ProcessingState.completed:
          break;
        case ProcessingState.ready:
          state.isLoading = false;
          emit(AudioPlayerState.clone(state));
          break;
      }
    });

    var checkAddedToPlaylist = await getPlaylistsContainingAudio(state.allAudioList[state.currentAudioIndex].id);
    bool isAddedToPlaylist = checkAddedToPlaylist.isNotEmpty;

    isAddedToPlaylist ? toggleIsAddedToPlaylist(true) : toggleIsAddedToPlaylist(false);

    state.isLoadingFavouriteAndDownload = false;

    audioPlayer.durationStream.listen((duration) {
      if (duration != null) {
        state.totalTimeMilliseconds = duration.inMilliseconds;
        state.timeLeft = getTimeLeftFromPercentage(0.0, state.totalTimeMilliseconds);
        emit(AudioPlayerState.clone(state));
      }
    });

    audioPlayer.positionStream.listen((position) {
      if (!state.isDraggingSlider) {
        int currentPosition = position.inMilliseconds;
        double percentage = (currentPosition / state.totalTimeMilliseconds) * 100;
        state.currentSliderValue = percentage;
        setTimeElapsedAndCurrentTime2();
        emit(AudioPlayerState.clone(state));
      }
    });

    if (!autoPlay) {
      await audioPlayer.pause();
    }
  }

  void setTimeElapsedAndCurrentTime2() {
    state.currentTime = getTimeFromPercentage(state.currentSliderValue, state.totalTimeMilliseconds);
    state.timeLeft = getTimeLeftFromPercentage(state.currentSliderValue, state.totalTimeMilliseconds);
    emit(AudioPlayerState.clone(state));
  }

  void playNextAudio() async {
    state.isDownloaded = state.isShuffleOn
        ? state.shuffledAudioList[state.currentAudioIndex].isDownloaded
        : state.allAudioList[state.currentAudioIndex].isDownloaded;

    if (state.currentAudioIndex < getCurrentPlaylist().length - 1) {
      state.currentAudioIndex++;
      updateCurrentAudioState();
      setAudioPlayer(getCurrentPlaylist()[state.currentAudioIndex].audioURL, state.isPaused ? true : false);
    } else {
      if (state.isLoopOn) {
        state.currentAudioIndex = 0;
        updateCurrentAudioState();
        setAudioPlayer(getCurrentPlaylist()[state.currentAudioIndex].audioURL, state.isPaused ? true : false);
      } else {
        state.currentAudioIndex = getCurrentPlaylist().length - 1;
        await audioPlayer.stop();
      }
    }
  }

  void playPreviousAudio() async {
    if (state.currentAudioIndex > 0) {
      state.currentAudioIndex--;
      updateCurrentAudioState();
      setAudioPlayer(getCurrentPlaylist()[state.currentAudioIndex].audioURL, state.isPaused ? true : false);
    }
  }

  void updateCurrentAudioState() {
    final currentAudio = getCurrentPlaylist()[state.currentAudioIndex];
    state.imageUrl = currentAudio.image;
    state.isAddedToPlaylist = currentAudio.isAddedToPlaylist;
    state.isDownloaded = currentAudio.isDownloaded;
    emit(AudioPlayerState.clone(state));
  }

  void toggleIsAddedToPlaylist(bool value) {
    state.isAddedToPlaylist = value;
    emit(AudioPlayerState.clone(state));
    print(state.isAddedToPlaylist);
  }

  void toggleIsPaused() async {
    state.isPaused = !state.isPaused;
    state.showMiniPlayer = true;
    if (!state.isPaused) {
      await audioPlayer.pause();
    } else {
      await audioPlayer.play();
    }

    emit(AudioPlayerState.clone(state));
  }

  void toggleIsLooped() {
    state.isLoopOn = !state.isLoopOn;
    emit(AudioPlayerState.clone(state));
  }

  void toggleIsShuffled() {
    final currentAudio = getCurrentPlaylist().isNotEmpty ? getCurrentPlaylist()[state.currentAudioIndex] : null;
    if (currentAudio == null) {
      return;
    }

    state.isShuffleOn = !state.isShuffleOn;
    if (state.isShuffleOn) {
      shufflePlaylist();
    } else {
      state.shuffledAudioList = [];
    }
    updateCurrentAudioIndex(currentAudio);
    emit(AudioPlayerState.clone(state));
  }

  void shufflePlaylist() {
    state.shuffledAudioList = List.from(state.allAudioList);
    if (state.shuffledAudioList.isNotEmpty) {
      state.shuffledAudioList.removeAt(state.currentAudioIndex);
      state.shuffledAudioList.shuffle(Random());
      state.shuffledAudioList.insert(0, state.allAudioList[state.currentAudioIndex]);
    }
  }

  void updateCurrentAudioIndex(LightLanguageAudioModel audioBeforeSwitch) {
    state.currentAudioIndex = getCurrentPlaylist().indexOf(audioBeforeSwitch);
  }

  void updateSliderValue(double value, {bool isDragging = false}) async {
    state.isDraggingSlider = isDragging;
    state.currentSliderValue = value;
    setTimeElapsedAndCurrentTime();

    int seekPosition = (value / 100 * state.totalTimeMilliseconds).round();
    if (!isDragging) {
      await audioPlayer.seek(Duration(milliseconds: seekPosition));
    }

    emit(AudioPlayerState.clone(state));
  }

  void skipForward() async {
    double skipDurationSeconds = 10;
    double skipPercentage = (skipDurationSeconds / (state.totalTimeMilliseconds / 1000)) * 100;
    state.currentSliderValue += skipPercentage;
    if (state.currentSliderValue > 100) {
      state.currentSliderValue = 100;
    }
    setTimeElapsedAndCurrentTime();

    int seekPosition = (state.currentSliderValue / 100 * state.totalTimeMilliseconds).round();
    await audioPlayer.seek(Duration(milliseconds: seekPosition));

    emit(AudioPlayerState.clone(state));
  }

  void skipBackwards() async {
    double skipDurationSeconds = 10;
    double skipPercentage = (skipDurationSeconds / (state.totalTimeMilliseconds / 1000)) * 100;
    state.currentSliderValue -= skipPercentage;
    if (state.currentSliderValue < 0) {
      state.currentSliderValue = 0;
    }
    setTimeElapsedAndCurrentTime();

    int seekPosition = (state.currentSliderValue / 100 * state.totalTimeMilliseconds).round();
    await audioPlayer.seek(Duration(milliseconds: seekPosition));

    emit(AudioPlayerState.clone(state));
  }

  void setPlaybackSpeed(double speed) async {
    state.playbackSpeed = speed;
    await audioPlayer.setSpeed(speed);
    emit(AudioPlayerState.clone(state));
  }

  void setTimeElapsedAndCurrentTime() {
    state.currentTime = getTimeFromPercentage(state.currentSliderValue, state.totalTimeMilliseconds);
    state.timeLeft = getTimeLeftFromPercentage(state.currentSliderValue, state.totalTimeMilliseconds);
    emit(AudioPlayerState.clone(state));
  }

  void stopAndHideMiniPlayer() async {
    state.showMiniPlayer = false;
    await audioPlayer.stop();
    emit(AudioPlayerState.clone(state));
  }

  void hideMiniPlayer() async {
    state.showMiniPlayer = false;
    emit(AudioPlayerState.clone(state));
  }

  void setBottomPadding(double padding) {
    state.bottomPadding = padding;
    emit(AudioPlayerState.clone(state));
  }

  Future<List<PlaylistItem>> getUserPlaylists() async {
    try {
      final token = await globalGetToken();
      List<PlaylistItem> playlists = await getUserPlaylistsSimpleUseCase.execute(token!);
      state.playlistsNames = playlists;
      emit(AudioPlayerState.clone(state));
      return playlists;
    } catch (e) {
      print("Failed to fetch playlists: $e");
      emit(AudioPlayerState.clone(state));
      return [];
    }
  }

  Future<Set<String>> getPlaylistsContainingAudio(int audioID) async {
    try {
      final playlists = await getUserPlaylists();
      Set<String> playlistNamesContainingAudio = {};

      for (PlaylistItem playlist in playlists) {
        bool containsAudio = playlist.audios.any((audio) => audio.id == audioID);
        if (containsAudio) {
          playlistNamesContainingAudio.add(playlist.title);
        }
      }

      state.savedInPlaylists = playlistNamesContainingAudio;
      emit(AudioPlayerState.clone(state));
      print(state.savedInPlaylists.length);
      return playlistNamesContainingAudio;
    } catch (e) {
      print("Failed to check playlists for audio: $e");
      return {};
    }
  }

  Future<void> addToPlaylist(int audioID, int playlistID, String filename) async {
    try {
      globalGetToken().then((token) => addAudioToPlaylistUseCase.execute(audioID, playlistID, token!));

      Set<String> playlistNamesContainingAudio = Set.from(state.savedInPlaylists);
      for (PlaylistItem playlist in state.playlistsNames) {
        if (playlist.id == playlistID) {
          playlistNamesContainingAudio.add(playlist.title);
        }
      }
      state.savedInPlaylists = playlistNamesContainingAudio;
      emit(AudioPlayerState.clone(state));

      toastification.show(
        style: ToastificationStyle.flatColored,
        type: ToastificationType.success,
        dragToClose: true,
        closeOnClick: true,
        alignment: Alignment.bottomCenter,
        autoCloseDuration: const Duration(seconds: 5),
        title: const Text('Audio Added Successfully'),
        description: Text('$filename has been added to the playlist'),
      );
    } catch (e) {
      print("Failed to add audios: $e");
    }
  }

  Future<void> removeFromPlaylist(int audioID, List<int> playlistIDs, String filename) async {
    try {
      globalGetToken().then((token) => removeAudioFromPlaylistUseCase.execute(audioID, playlistIDs, token!));

      Set<String> playlistNamesContainingAudio = Set.from(state.savedInPlaylists);
      for (PlaylistItem playlist in state.playlistsNames) {
        if (playlist.id == playlistIDs.first) {
          playlistNamesContainingAudio.remove(playlist.title);
        }
      }
      state.savedInPlaylists = playlistNamesContainingAudio;
      emit(AudioPlayerState.clone(state));

      toastification.show(
        style: ToastificationStyle.flatColored,
        type: ToastificationType.success,
        dragToClose: true,
        closeOnClick: true,
        alignment: Alignment.bottomCenter,
        autoCloseDuration: const Duration(seconds: 5),
        title: const Text('Audio Removed Successfully'),
        description: Text('$filename has been removed from the playlist'),
      );
    } catch (e) {
      print("Failed to remove audios: $e");
    }
  }

  Future getPlaylists() async {
    final playlists = await getUserPlaylists();
    state.playlistsNames = playlists;
    emit(AudioPlayerState.clone(state));
  }

  Future getVaults() async {
    var list = await globalLoadVaults();
    state.vaultNames = list ?? [];
    emit(AudioPlayerState.clone(state));
  }

  void reset() {
    emit(AudioPlayerState());
  }

  ////----------------------------------------------------
  //// Helper Methods
  ////----------------------------------------------------

  List<LightLanguageAudioModel> getCurrentPlaylist() {
    final playlist = state.isShuffleOn ? state.shuffledAudioList : state.allAudioList;
    return playlist;
  }

  String getTimeFromPercentage(double percentage, int totalTimeMillis) {
    if (percentage < 0 || percentage > 100) {
      throw ArgumentError('Percentage must be between 0 and 100.');
    }

    int totalSeconds = totalTimeMillis ~/ 1000;
    int currentTimeInSeconds = (percentage / 100 * totalSeconds).round();

    int minutes = currentTimeInSeconds ~/ 60;
    int seconds = currentTimeInSeconds % 60;

    String minutesStr = minutes.toString().padLeft(2, '0');
    String secondsStr = seconds.toString().padLeft(2, '0');

    return "$minutesStr:$secondsStr";
  }

  String getTimeLeftFromPercentage(double percentage, int totalTimeMillis) {
    if (percentage < 0 || percentage > 100) {
      throw ArgumentError('Percentage must be between 0 and 100.');
    }

    int totalSeconds = totalTimeMillis ~/ 1000;
    int currentTimeInSeconds = (percentage / 100 * totalSeconds).round();
    int timeLeftInSeconds = totalSeconds - currentTimeInSeconds;

    int minutesLeft = timeLeftInSeconds ~/ 60;
    int secondsLeft = timeLeftInSeconds % 60;

    String minutesLeftStr = minutesLeft.toString().padLeft(2, '0');
    String secondsLeftStr = secondsLeft.toString().padLeft(2, '0');

    return "$minutesLeftStr:$secondsLeftStr";
  }
}
