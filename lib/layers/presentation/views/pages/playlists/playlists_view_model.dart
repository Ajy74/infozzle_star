import 'package:breathpacer/layers/domain/models/playlist_model.dart';
import 'package:breathpacer/layers/domain/use_cases/database/add_audio_to_playlist_use_case.dart';
import 'package:breathpacer/layers/domain/use_cases/database/create_playlist_use_case.dart';
import 'package:breathpacer/layers/domain/use_cases/database/delete_playlist_use_case.dart';
import 'package:breathpacer/layers/domain/use_cases/database/edit_playlist_name_use_case.dart';
import 'package:breathpacer/layers/domain/use_cases/database/get_curated_playlists_use_case.dart';
import 'package:breathpacer/layers/domain/use_cases/database/remove_audio_from_playlists_use_case.dart';
import 'package:breathpacer/layers/presentation/views/pages/playlists/playlists_state.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';

import '../../../../core/globals.dart';
import '../../../../domain/models/audio_section_model.dart';
import '../../../../domain/models/light_language_audio.dart';
import '../../../../domain/models/vaults_model.dart';
import '../../../../domain/use_cases/database/get_user_playlists_simple_use_case.dart';
import '../../../../domain/use_cases/database/upade_audio_use_case.dart';

class PlaylistsViewModel extends Cubit<PlaylistsState> {
  PlaylistsViewModel() : super(PlaylistsState()) {
    populatePlaylistList();
    getVaults();
  }

  final dio = Dio();
  CreatePlaylistUseCase createPlaylistUseCase = CreatePlaylistUseCase();
  RemoveAudioFromPlaylistUseCase removeAudioFromPlaylistUseCase = RemoveAudioFromPlaylistUseCase();
  DeletePlaylistUseCase deletePlaylistUseCase = DeletePlaylistUseCase();
  GetUserPlaylistsSimpleUseCase getUserPlaylistsSimpleUseCase = GetUserPlaylistsSimpleUseCase();
  GetCuratedPlaylistsUseCase getCuratedPlaylistsUseCase = GetCuratedPlaylistsUseCase();
  EditPlaylistNameUseCase editPlaylistNameUseCase = EditPlaylistNameUseCase();
  AddAudioToPlaylistUseCase addAudioToPlaylistUseCase = AddAudioToPlaylistUseCase();
  UpdateAudioUseCase updateAudioUseCase = UpdateAudioUseCase();

  Future<void> populatePlaylistList() async {
    await getCuratedPlaylists();
  }

  Future<void> getCuratedPlaylists() async {
    state.isPlaylistsLoading = true;
    emit(PlaylistsState.clone(state));
    try {
      final token = await globalGetToken();
      var finalPlaylists = await getCuratedPlaylistsUseCase.execute(token!);
      state.playlists = finalPlaylists;
    } catch (e) {
      state.showErrorMessage = true;
      state.errorTitle = "Failed to Fetch Playlists";
      state.errorMessage = "An error occurred while fetching playlist, please try again.";
      print("Failed to fetch playlists: $e");
    }
    state.isPlaylistsLoading = false;
    emit(PlaylistsState.clone(state));
  }

  Future<List<AudioSectionModel>> updateAudioInfo(List<AudioSectionModel> oldAudios, int playlistId) async {
    state.isLoading = true;
    emit(PlaylistsState.clone(state));
    try {
      final token = await globalGetToken();
      var updatedAudios = await updateAudioUseCase.execute(token!, oldAudios, playlistId);
      return updatedAudios;
    } catch (e) {
      state.showErrorMessage = true;
      state.errorTitle = "Failed to Update Audio";
      state.errorMessage = "An error occurred while updating audio, please try again.";
      print("Failed to update audio: $e");
    }
    state.isLoading = false;
    emit(PlaylistsState.clone(state));
    return [];
  }

  Future<void> listUpdate(PlaylistItem item) async {
    state.isLoading = true;
    emit(PlaylistsState.clone(state));
    try {
      var newAudio = await updateAudioInfo(item.audios, item.id);
      var newPlaylistItem = PlaylistItem(
          id: item.id, title: item.title, image: item.image, description: item.description, audios: newAudio);
      state.currentPlaylist = newPlaylistItem;
      emit(PlaylistsState.clone(state));
    } catch (e) {
      print("Failed to update audio: $e");
    }
    state.isLoading = false;
    emit(PlaylistsState.clone(state));
  }

  Future<List<PlaylistItem>> getUserPlaylists() async {
    try {
      final token = await globalGetToken();
      List<PlaylistItem> playlists = await getUserPlaylistsSimpleUseCase.execute(token!);
      state.playlistsNames = playlists;
      emit(PlaylistsState.clone(state));
      return playlists;
    } catch (e) {
      state.showErrorMessage = true;
      state.errorTitle = "Failed to Fetch Playlists";
      state.errorMessage = "An error occurred while fetching playlist, please try again.";
      print("Failed to fetch playlists: $e");
      emit(PlaylistsState.clone(state));
      return [];
    }
  }

  Future<List<PlaylistItem>> getUserPlaylistsLoading() async {
    state.isUserPlaylistsLoading = true;
    emit(PlaylistsState.clone(state));

    try {
      final token = await globalGetToken();
      List<PlaylistItem> playlists = await getUserPlaylistsSimpleUseCase.execute(token!);
      state.playlistsNames = playlists;
      state.isUserPlaylistsLoading = false;
      emit(PlaylistsState.clone(state));
      return playlists;
    } catch (e) {
      state.showErrorMessage = true;
      state.errorTitle = "Failed to Fetch Playlists";
      state.errorMessage = "An error occurred while fetching playlist, please try again.";
      print("Failed to fetch playlists: $e");
      emit(PlaylistsState.clone(state));
    }
    state.isUserPlaylistsLoading = false;
    emit(PlaylistsState.clone(state));
    return [];
  }

  Future<void> addToPlaylist(int audioID, int playlistID, String filename) async {
    try {
      globalGetToken().then((token) => addAudioToPlaylistUseCase.execute(audioID, playlistID, token!));

      Map<int, Set<String>> savedInPlaylistsMap = Map.from(state.savedInPlaylists);
      Set<String> playlistNamesContainingAudio = Set.from(savedInPlaylistsMap[audioID] ?? {});
      for (PlaylistItem playlist in state.playlistsNames) {
        if (playlist.id == playlistID) {
          playlistNamesContainingAudio.add(playlist.title);
        }
      }
      savedInPlaylistsMap[audioID] = playlistNamesContainingAudio;
      state.savedInPlaylists = savedInPlaylistsMap;
      emit(PlaylistsState.clone(state));

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

      Map<int, Set<String>> savedInPlaylistsMap = Map.from(state.savedInPlaylists);
      Set<String> playlistNamesContainingAudio = Set.from(savedInPlaylistsMap[audioID] ?? {});
      for (PlaylistItem playlist in state.playlistsNames) {
        if (playlist.id == playlistIDs.first) {
          playlistNamesContainingAudio.remove(playlist.title);
        }
      }
      savedInPlaylistsMap[audioID] = playlistNamesContainingAudio;
      state.savedInPlaylists = savedInPlaylistsMap;
      print(savedInPlaylistsMap);
      emit(PlaylistsState.clone(state));

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

  void getPlaylistsContainingAudio() {
    try {
      Map<int, Set<String>> savedInPlaylistsMap = Map.from(state.savedInPlaylists);

      for (var a in state.currentPlaylist.audios) {
        Set<String> playlistNamesContainingAudio = {};
        for (PlaylistItem playlist in state.playlistsNames) {
          bool containsAudio = playlist.audios.any((audio) => audio.id == a.id);
          if (containsAudio) {
            playlistNamesContainingAudio.add(playlist.title);
          }
        }
        savedInPlaylistsMap[a.id] = playlistNamesContainingAudio;
      }

      state.savedInPlaylists = savedInPlaylistsMap;
      emit(PlaylistsState.clone(state));
    } catch (e) {
      print("Failed to check playlists for audio: $e");
    }
  }

  void setCurrentAudio(AudioSectionModel model) {
    state.audio = model;
    emit(PlaylistsState.clone(state));
  }

  Future<void> renamePlaylist(int id, String newName) async {
    try {
      final token = await globalGetToken();
      await editPlaylistNameUseCase.execute(id, newName, token!);
      List<PlaylistItem> updatedPlaylists = await getUserPlaylists();
      state.playlistsNames = updatedPlaylists;
      emit(PlaylistsState.clone(state));
    } catch (e) {
      state.showErrorMessage = true;
      state.errorTitle = "Failed to Rename Playlist";
      state.errorMessage = "An error occurred while renaming playlist, please try again.";
      print("Failed to rename playlist: $e");
      emit(PlaylistsState.clone(state));
    }
    emit(PlaylistsState.clone(state));
  }

  Future<void> addPlaylist(String title) async {
    try {
      final token = await globalGetToken();
      await createPlaylistUseCase.execute(title, token!);
      List<PlaylistItem> updatedPlaylists = await getUserPlaylists();
      state.playlistsNames = updatedPlaylists;
      emit(PlaylistsState.clone(state));
    } catch (e) {
      state.showErrorMessage = true;
      state.errorTitle = "Failed to Create Playlist";
      state.errorMessage = "An error occurred while creating playlist, please try again.";
      print("Failed to create playlist: $e");
      emit(PlaylistsState.clone(state));
    }
  }

  Future<void> deletePlaylist(int id) async {
    try {
      final token = await globalGetToken();
      await deletePlaylistUseCase.execute(id, token!);

      List<PlaylistItem> updatedPlaylists = await getUserPlaylistsSimpleUseCase.execute(token);
      state.playlistsNames = updatedPlaylists;
      emit(PlaylistsState.clone(state));
    } catch (e) {
      print("Failed to delete playlist: $e");
      emit(PlaylistsState.clone(state));
    }
  }

  void toggleIsAddedToPlaylist(bool value) {
    state.audio = state.audio.copyWith(isAddedToPlaylist: value);
    state.isAddedToPlaylist = value;
    emit(PlaylistsState.clone(state));
  }

  void toggleIsLiked() {
    state.audio = state.audio.copyWith(isLiked: !state.audio.isLiked);
    emit(PlaylistsState.clone(state));
  }

  void updateCurrentAudioState() {
    final currentAudio = state.audio;
    state.isAddedToPlaylist = currentAudio.isAddedToPlaylist;
    state.isDownloaded = currentAudio.isDownloaded;
    state.savedInVaults = currentAudio.savedInVaults;
    emit(PlaylistsState.clone(state));
  }

  Future getPlaylists() async {
    final playlists = await getUserPlaylists();
    state.playlistsNames = playlists;
    emit(PlaylistsState.clone(state));
  }

  Future getVaults() async {
    var list = await globalLoadVaults();
    state.vaultNames = list ?? [];
    emit(PlaylistsState.clone(state));
  }

  Future<void> addVault(String title) async {
    await globalAddVault(VaultsModel(title: title, audios: []));
  }

  Future<void> deleteVault(String vaultName) async {
    var vault = state.vaultNames.firstWhere((vault) => vault.title == vaultName);

    await globalRemoveVault(vaultName, vault.audios);
  }

  Future<void> checkIfVaultExists(String title) async {
    var allVaults = await globalLoadVaults();
    bool vaultFound = false;

    for (var vault in allVaults!) {
      if (vault.title == title) {
        vaultFound = true;
        break;
      }
    }
    toggleIsFound(vaultFound);
  }

  void toggleIsFound(bool value) {
    state.isVaultFound = value;
    emit(PlaylistsState.clone(state));
  }

  LightLanguageAudioModel mapVaultAudio(AudioSectionModel audio) {
    var vaultAudio = (LightLanguageAudioModel(
        id: audio.id,
        title: audio.title,
        image: audio.image,
        audioURL: audio.audioURL,
        originalURL: audio.originalURL,
        isDownloaded: audio.isDownloaded,
        isAddedToPlaylist: false,
        savedInPlaylists: [],
        savedInVaults: [],
        downloadedAt: ""));

    return vaultAudio;
  }

  void reset() {
    emit(PlaylistsState());
  }
}
