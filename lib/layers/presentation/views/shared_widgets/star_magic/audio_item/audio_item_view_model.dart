import 'package:audioplayers/audioplayers.dart';
import 'package:breathpacer/layers/core/globals.dart';
import 'package:breathpacer/layers/domain/models/audio_section_model.dart';
import 'package:breathpacer/layers/domain/use_cases/database/add_like_use_case.dart';
import 'package:breathpacer/layers/domain/use_cases/database/remove_like_use_case.dart';
import 'package:breathpacer/layers/presentation/download_manager/download_helper.dart';
import 'package:breathpacer/layers/presentation/views/shared_widgets/star_magic/audio_item/audio_item_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';

import '../../../../../domain/models/playlist_model.dart';
import '../../../../../domain/use_cases/database/add_audio_to_playlist_use_case.dart';
import '../../../../../domain/use_cases/database/get_single_audio_use_case.dart';
import '../../../../../domain/use_cases/database/get_user_playlists_simple_use_case.dart';
import '../../../../../domain/use_cases/database/remove_audio_from_playlists_use_case.dart';

class AudioItemViewModel extends Cubit<AudioItemState> {
  AudioItemViewModel() : super(AudioItemState());

  final dio = Dio();
  final audioPlayer = AudioPlayer();
  AddLikeUseCase addLikeUseCase = AddLikeUseCase();
  RemoveLikeUseCase removeLikeUseCase = RemoveLikeUseCase();
  AddAudioToPlaylistUseCase addAudioToPlaylistUseCase = AddAudioToPlaylistUseCase();
  RemoveAudioFromPlaylistUseCase removeAudioFromPlaylistUseCase = RemoveAudioFromPlaylistUseCase();
  GetUserPlaylistsSimpleUseCase getUserPlaylistsSimpleUseCase = GetUserPlaylistsSimpleUseCase();
  GetSingleAudioUseCase getSingleAudioUseCase = GetSingleAudioUseCase();

  Future setModel(AudioSectionModel model) async {
    state.isLoading = true;
    emit(AudioItemState.clone(state));
    var moreInfo = await getAudioInfo(model.id.toString());
    state.audio = moreInfo;
    state.isLoading = false;
    emit(AudioItemState.clone(state));

    state.isLoadingUserPlaylists = true;
    await getPlaylistsContainingAudio(model.id);
    emit(AudioItemState.clone(state));
    state.isLoadingUserPlaylists = false;
    emit(AudioItemState.clone(state));
  }

  Future<AudioSectionModel> getAudioInfo(String audioID) async {
    try {
      final token = await globalGetToken();
      final info = await getSingleAudioUseCase.execute(audioID, token!);
      if (info.isLiked) state.isLiked = true;
      state.isDownloaded = (await DownloadHelper.getDownloadedPath(int.parse(audioID))) != null;
      return info;
    } catch (e) {
      state.showErrorMessage = true;
      print("Failed to get audio item info : $e");
    }
    return AudioSectionModel(
        id: 0,
        title: "title",
        image: "",
        time: "",
        description: "",
        audioURL: "",
        unlocked: false,
        originalURL: '',
        isDownloaded: false,
        isLiked: false,
        isAddedToPlaylist: false,
        numOfLikes: 0,
        savedInPlaylists: [],
        savedInVaults: []);
  }

  void toggleIsAddedToPlaylist(bool value) {
    state.audio = state.audio.copyWith(isAddedToPlaylist: value);
    state.isAddedToPlaylist = value;
    emit(AudioItemState.clone(state));
  }

  Future<void> toggleLiked(AudioSectionModel audio) async {
    try {
      if (audio.isLiked || state.isLiked) {
        audio.copyWith(isLiked: false, numOfLikes: audio.numOfLikes - 1);
        globalGetToken().then((token) => removeLikeUseCase.execute(audio.id, token!));
        state.isLiked = false;
      } else {
        audio = audio.copyWith(isLiked: true, numOfLikes: audio.numOfLikes + 1);
        globalGetToken().then((token) => addLikeUseCase.execute(audio.id, token!));
        state.isLiked = true;
      }
    } catch (e) {
      state.showErrorMessage = true;
      print("Failed to update like value: $e");
    }
    emit(AudioItemState.clone(state));
  }

  void updateCurrentAudioState() {
    final currentAudio = state.audio;
    state.isAddedToPlaylist = currentAudio.isAddedToPlaylist;
    state.isDownloaded = currentAudio.isDownloaded;
    emit(AudioItemState.clone(state));
  }

  Future<List<PlaylistItem>> getUserPlaylists() async {
    emit(AudioItemState.clone(state));
    try {
      final token = await globalGetToken();
      List<PlaylistItem> playlists = await getUserPlaylistsSimpleUseCase.execute(token!);
      state.playlistsNames = playlists;
      emit(AudioItemState.clone(state));
      return playlists;
    } catch (e) {
      print("Failed to fetch playlists: $e");
      emit(AudioItemState.clone(state));
    }
    emit(AudioItemState.clone(state));
    return [];
  }

  Future<Set<String>> getPlaylistsContainingAudio(int audioID) async {
    try {
      final playlists = await getUserPlaylists();
      Set<String> playlistNamesContainingAudio = {};

      for (PlaylistItem playlist in playlists) {
        bool containsAudio = playlist.audios.any((audio) => audio.id == audioID);
        if (containsAudio) {
          playlistNamesContainingAudio.add(playlist.title);
          state.isAddedToPlaylist = true;
          emit(AudioItemState.clone(state));
        }
      }

      state.savedInPlaylists = playlistNamesContainingAudio;
      emit(AudioItemState.clone(state));
      return playlistNamesContainingAudio;
    } catch (e) {
      print("Failed to check playlists for audio: $e");
      return {};
    }
  }

  Future<void> addToPlaylist(int audioID, int playlistID, String filename) async {
    emit(AudioItemState.clone(state));
    try {
      globalGetToken().then((token) => addAudioToPlaylistUseCase.execute(audioID, playlistID, token!));

      Set<String> playlistNamesContainingAudio = Set.from(state.savedInPlaylists);
      for (PlaylistItem playlist in state.playlistsNames) {
        if (playlist.id == playlistID) {
          playlistNamesContainingAudio.add(playlist.title);
        }
      }
      state.savedInPlaylists = playlistNamesContainingAudio;
      emit(AudioItemState.clone(state));

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
      emit(AudioItemState.clone(state));

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
    emit(AudioItemState.clone(state));
  }

  Future getVaults() async {
    var list = await globalLoadVaults();
    state.vaultNames = list ?? [];
    emit(AudioItemState.clone(state));
  }

  void updateIsDownloaded(bool value) {
    state.isDownloaded = value;
    emit(AudioItemState.clone(state));
  }

  void reset() {
    emit(AudioItemState());
  }
}
