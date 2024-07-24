import 'package:flutter/cupertino.dart';

import '../../../../domain/models/light_language_audio.dart';
import '../../../../domain/models/playlist_model.dart';
import '../../../../domain/models/vaults_model.dart';

class AudioPlayerState extends ChangeNotifier {
  List<LightLanguageAudioModel> allAudioList;
  List<LightLanguageAudioModel> shuffledAudioList;
  List<PlaylistItem> playlistsNames;
  List<VaultsModel> vaultNames;
  Set<String> savedInPlaylists;
  List<String> savedInVaults;
  String imageUrl;
  String title;
  String currentTime;
  String timeLeft;
  bool isAddedToPlaylist;
  bool isDownloaded;
  bool isPaused;
  bool isShuffleOn;
  bool isLoopOn;
  bool isLoadingFavouriteAndDownload;
  bool isSpeedSelected;
  bool showMiniPlayer;
  bool isDraggingSlider;
  bool isLoading;
  double bottomPadding;
  double playbackSpeed;
  double currentSliderValue;
  int totalTimeMilliseconds;
  int currentAudioIndex;

  AudioPlayerState(
      {this.allAudioList = const [],
      this.shuffledAudioList = const [],
      this.playlistsNames = const [],
      this.isSpeedSelected = false,
      this.vaultNames = const [],
      this.savedInPlaylists = const {},
      this.savedInVaults = const [],
      this.title = "",
      this.isLoadingFavouriteAndDownload = false,
      this.imageUrl = "https://placehold.co/300x300.jpg",
      this.currentTime = "00:00",
      this.timeLeft = "00:00",
      this.isAddedToPlaylist = false,
      this.isDownloaded = false,
      this.isLoopOn = false,
      this.isLoading = false,
      this.isShuffleOn = false,
      this.isPaused = false,
      this.isDraggingSlider = false,
      this.showMiniPlayer = false,
      this.bottomPadding = 0.0,
      this.playbackSpeed = 1.0,
      this.currentSliderValue = 0.0,
      this.totalTimeMilliseconds = 600000,
      this.currentAudioIndex = 0});

  AudioPlayerState.clone(AudioPlayerState existingState)
      : this(
            allAudioList: existingState.allAudioList,
            shuffledAudioList: existingState.shuffledAudioList,
            playlistsNames: existingState.playlistsNames,
            vaultNames: existingState.vaultNames,
            savedInPlaylists: existingState.savedInPlaylists,
            savedInVaults: existingState.savedInVaults,
            title: existingState.title,
            imageUrl: existingState.imageUrl,
            timeLeft: existingState.timeLeft,
            currentTime: existingState.currentTime,
            isSpeedSelected: existingState.isSpeedSelected,
            isAddedToPlaylist: existingState.isAddedToPlaylist,
            isDownloaded: existingState.isDownloaded,
            isLoopOn: existingState.isLoopOn,
            isLoadingFavouriteAndDownload: existingState.isLoadingFavouriteAndDownload,
            isLoading: existingState.isLoading,
            isShuffleOn: existingState.isShuffleOn,
            isPaused: existingState.isPaused,
            showMiniPlayer: existingState.showMiniPlayer,
            isDraggingSlider: existingState.isDraggingSlider,
            bottomPadding: existingState.bottomPadding,
            playbackSpeed: existingState.playbackSpeed,
            currentSliderValue: existingState.currentSliderValue,
            totalTimeMilliseconds: existingState.totalTimeMilliseconds,
            currentAudioIndex: existingState.currentAudioIndex);
}
