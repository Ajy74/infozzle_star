import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/globals.dart';
import '../../../../domain/models/light_language_audio.dart';
import '../../../../domain/use_cases/database/get_light_language_audios_use_case.dart';
import 'light_language_state.dart';

class LightLanguageViewModel extends Cubit<LightLanguageState> {
  LightLanguageViewModel() : super(LightLanguageState()) {
    fetchAudios();
  }

  final SearchController controller = SearchController();
  GetLightLanguageAudiosUseCase getLightLanguageAudiosUseCase = GetLightLanguageAudiosUseCase();
  List<LightLanguageAudioModel> _allAudioList = [];

  Future<void> fetchAudios() async {
    state.isLoading = true;
    emit(LightLanguageState.clone(state));
    try {
      final token = await globalGetToken();
      final audios = await getLightLanguageAudiosUseCase.execute(token!);
      _allAudioList = audios;
      state.audioList = _allAudioList;
    } catch (e) {
      state.showErrorMessage = true;
      print("Failed to fetch light language audios: $e");
    }
    state.isLoading = false;
    emit(LightLanguageState.clone(state));
  }

  void filterAudioList(String searchText) {
    if (searchText.isEmpty) {
      state.audioList = _allAudioList;
    } else {
      state.audioList = _allAudioList.where((audio) {
        return audio.title.toLowerCase().contains(searchText.toLowerCase());
      }).toList();
    }
  }

  void updateSearchText() {
    state.currentSearchText = controller.text;
    filterAudioList(state.currentSearchText);
    emit(LightLanguageState.clone(state));
  }

  void moveToBeginning(List list, int index) {
    if (index >= 0 && index < list.length) {
      var item = list.removeAt(index);
      list.insert(0, item);
    }
  }

  void reset() {
    emit(LightLanguageState());
  }
}
