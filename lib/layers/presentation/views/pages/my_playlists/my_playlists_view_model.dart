import 'package:breathpacer/layers/core/globals.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:toastification/toastification.dart';

import '../../../../domain/models/playlist_model.dart';
import '../../../../domain/use_cases/database/create_playlist_use_case.dart';
import '../../../../domain/use_cases/database/delete_playlist_use_case.dart';
import '../../../../domain/use_cases/database/edit_playlist_name_use_case.dart';
import '../../../../domain/use_cases/database/get_user_playlists_use_case.dart';
import '../../../../domain/use_cases/database/remove_audio_from_playlists_use_case.dart';
import 'my_playlists_state.dart';

class MyPlaylistsViewModel extends Cubit<MyPlaylistsState> {
  MyPlaylistsViewModel() : super(MyPlaylistsState()) {
    getUserPlaylists();
  }

  GetUserPlaylistsUseCase getUserPlaylistsUseCase = GetUserPlaylistsUseCase();
  CreatePlaylistUseCase createPlaylistUseCase = CreatePlaylistUseCase();
  DeletePlaylistUseCase deletePlaylistUseCase = DeletePlaylistUseCase();
  EditPlaylistNameUseCase editPlaylistNameUseCase = EditPlaylistNameUseCase();
  RemoveAudioFromPlaylistUseCase removeAudioFromPlaylistUseCase = RemoveAudioFromPlaylistUseCase();

  Future<List<PlaylistItem>> getUserPlaylists() async {
    state.isLoading = true;
    emit(MyPlaylistsState.clone(state));
    try {
      final token = await globalGetToken();
      print(token);
      List<PlaylistItem> playlists = await getUserPlaylistsUseCase.execute(token!);
      state.playlists = playlists;
      state.isLoading = false;
      emit(MyPlaylistsState.clone(state));
      return playlists;
    } catch (e) {
      state.showErrorMessage = true;
      state.errorTitle = "Failed to Fetch User Playlists";
      state.errorMessage = "An error occurred while fetching playlists, please try again.";
      print("Failed to fetch user playlists: $e");
      emit(MyPlaylistsState.clone(state));
      return [];
    }
  }

  Future<bool> checkIfVaultExists(String title) async {
    var allVaults = await globalLoadVaults();
    for (var vault in allVaults!) {
      if (vault.title == title) {
        return true;
      }
    }
    return false;
  }

  Future<void> renamePlaylist(int id, String newName) async {
    try {
      final token = await globalGetToken();
      await editPlaylistNameUseCase.execute(id, newName, token!);
      List<PlaylistItem> updatedPlaylists = await getUserPlaylists();
      state.playlists = updatedPlaylists;
      emit(MyPlaylistsState.clone(state));
    } catch (e) {
      state.showErrorMessage = true;
      state.errorTitle = "Failed to Rename Playlist";
      state.errorMessage = "An error occurred while renaming playlist, please try again.";
      print("Failed to rename playlist: $e");
      emit(MyPlaylistsState.clone(state));
    }
    emit(MyPlaylistsState.clone(state));
  }

  Future<void> addPlaylist(String title) async {
    try {
      final token = await globalGetToken();
      await createPlaylistUseCase.execute(title, token!);
      List<PlaylistItem> updatedPlaylists = await getUserPlaylists();
      state.playlists = updatedPlaylists;
      emit(MyPlaylistsState.clone(state));
    } catch (e) {
      state.showErrorMessage = true;
      state.errorTitle = "Failed to Create Playlist";
      state.errorMessage = "An error occurred while creating playlist, please try again.";
      print("Failed to create playlist: $e");
      emit(MyPlaylistsState.clone(state));
    }
  }

  Future<void> deletePlaylist(int id) async {
    try {
      final token = await globalGetToken();
      await deletePlaylistUseCase.execute(id, token!);

      List<PlaylistItem> updatedPlaylists = await getUserPlaylistsUseCase.execute(token);
      state.playlists = updatedPlaylists;
      emit(MyPlaylistsState.clone(state));
    } catch (e) {
      print("Failed to delete playlist: $e");
      emit(MyPlaylistsState.clone(state));
    }
  }

  Future<void> removeFromPlaylist(int audioID, List<int> playlistId, String filename) async {
    try {
      final token = await globalGetToken();
      await removeAudioFromPlaylistUseCase.execute(audioID, playlistId, token!);
      toastification.show(
        style: ToastificationStyle.flatColored,
        type: ToastificationType.success,
        dragToClose: true,
        closeOnClick: true,
        alignment: Alignment.bottomCenter,
        autoCloseDuration: const Duration(seconds: 5),
        title: const Text('Audio Removed Successfully'),
        description: Text('$filename has been removed to the playlist'),
      );
      await getUserPlaylists();
    } catch (e) {
      print("Failed to add audios: $e");
    }
    emit(MyPlaylistsState.clone(state));
  }

  void resetErrorState() {
    state.showErrorMessage = false;
    state.errorTitle = "";
    state.errorMessage = "";
    emit(MyPlaylistsState.clone(state));
  }

  void reset() {
    emit(MyPlaylistsState());
  }
}
