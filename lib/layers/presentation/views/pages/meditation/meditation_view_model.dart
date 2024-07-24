import 'package:breathpacer/layers/domain/use_cases/database/add_like_use_case.dart';
import 'package:breathpacer/layers/domain/use_cases/database/get_all_meditations_use_case.dart';
import 'package:breathpacer/layers/domain/use_cases/database/get_dashboard_use_case.dart';
import 'package:breathpacer/layers/domain/use_cases/database/get_playlist_meditations_use_case.dart';
import 'package:breathpacer/layers/domain/use_cases/database/remove_like_use_case.dart';
import 'package:breathpacer/layers/presentation/views/pages/meditation/meditation_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/globals.dart';
import '../../../../domain/models/audio_section_model.dart';
import '../../../../domain/use_cases/database/get_meditations_use_case.dart';

class MeditationViewModel extends Cubit<MeditationState> {
  MeditationViewModel() : super(MeditationState()) {
    populateMeditationsList();
    checkIfGuest();
    getSearchResults();
  }

  final TextEditingController searchController = TextEditingController();
  final GetMeditationsUseCase getMeditationsUseCase = GetMeditationsUseCase();
  final GetPlaylistMeditations getPlaylistMeditations = GetPlaylistMeditations();
  final GetDashboardUseCase getDashboardUseCase = GetDashboardUseCase();
  final RemoveLikeUseCase removeLikeUseCase = RemoveLikeUseCase();
  final AddLikeUseCase addLikeUseCase = AddLikeUseCase();
  final GetAllMeditationsUseCase getAllMeditationsUseCase = GetAllMeditationsUseCase();

  List<AudioSectionModel> allMeditations = [];

  Future<void> populateMeditationsList() async {
    state.isLoading = true;
    emit(MeditationState.clone(state));
    try {
      final meditations = await getMeditationsUseCase.execute();
      state.meditations = meditations;
    } catch (e) {
      state.errorTitle = "Failed to fetch Meditations";
      state.errorMessage = "An error occurred while fetching data, please try again.";
      state.showErrorMessage = true;
      print("Failed to fetch meditations: $e");
    }
    state.isLoading = false;
    emit(MeditationState.clone(state));
  }

  Future<List<AudioSectionModel>> fetchPlaylistMeditations(int playlistId) async {
    List<AudioSectionModel> audios = [];
    state.isLoading = true;
    emit(MeditationState.clone(state));
    try {
      final token = await globalGetToken();
      final meditations = await getPlaylistMeditations.execute(token!, playlistId);
      audios = meditations;
    } catch (e) {
      state.errorTitle = "Failed to fetch Meditations";
      state.errorMessage = "An error occurred while fetching data, please try again.";
      state.showErrorMessage = true;
      print("Failed to fetch meditations: $e");
    }
    state.isLoading = false;
    emit(MeditationState.clone(state));
    return audios;
  }

  void updateSearchText() {
    state.currentSearchText = searchController.text;
    filterAudioList(state.currentSearchText);
    emit(MeditationState.clone(state));
  }

  Future<void> getSearchResults() async {
    var list = await getAllMeditations(false);
    allMeditations = list;
  }

  Future<void> filterAudioList(String searchText) async {
    if (searchText.isEmpty) {
      state.filteredAudios = [];
    } else {
      Set<int> uniqueIds = {};
      List<AudioSectionModel> filteredAudios = [];

      for (var meditation in allMeditations) {
        if (meditation.title.toLowerCase().contains(searchText.toLowerCase())) {
          if (!uniqueIds.contains(meditation.id)) {
            filteredAudios.add(meditation);
            uniqueIds.add(meditation.id);
          }
        }
      }

      state.filteredAudios = filteredAudios;
    }
  }

  List<AudioSectionModel> getFilteredAudios() {
    return state.filteredAudios;
  }

  Future<List<AudioSectionModel>> getAllMeditations(bool value) async {
    List<AudioSectionModel> all = [];
    state.isLoading = true;
    emit(MeditationState.clone(state));
    try {
      var list = await getAllMeditationsUseCase.execute(value);
      for (var item in list) {
        for (var audio in item.audios) {
          all.add(audio);
        }
      }
    } catch (e) {
      state.errorTitle = "Failed to fetch Meditations";
      state.errorMessage = "An error occurred while fetching data, please try again.";
      state.showErrorMessage = true;
      print("Failed to fetch meditations: $e");
    }
    emit(MeditationState.clone(state));
    return all;
  }

  Future<List<AudioSectionModel>> getMeditationsForGroup(String id) async {
    state.isLoading = true;
    emit(MeditationState.clone(state));

    List<AudioSectionModel> all = [];
    for (var item in state.meditations) {
      if (item.playlistId == id) {
        all.addAll(item.audios);
      }
    }
    return all;
  }

  Future<void> checkIfGuest() async {
    state.isActive = globalIsActive;
    state.isGuest = !globalLoggedIn;
    await globalCheckIfLoggedIn();
    state.isActive = globalIsActive;
    state.isGuest = !globalLoggedIn;
    emit(MeditationState.clone(state));
  }

  Future<void> toggleLiked(AudioSectionModel challenge, int index, List<AudioSectionModel> challenges) async {
    try {
      final token = await globalGetToken();

      if (challenges[index].isLiked) {
        challenges[index] = challenges[index].copyWith(isLiked: false, numOfLikes: challenges[index].numOfLikes - 1);
        await removeLikeUseCase.execute(challenges[index].id, token!);
      } else {
        challenges[index] = challenges[index].copyWith(isLiked: true, numOfLikes: challenges[index].numOfLikes + 1);
        await addLikeUseCase.execute(challenges[index].id, token!);
      }
    } catch (e) {
      print("Failed to update like value: $e");
    }
    emit(MeditationState.clone(state));
  }

  void reset() {
    emit(MeditationState());
  }
}
