import 'package:breathpacer/layers/domain/models/audio_section_model.dart';
import 'package:breathpacer/layers/domain/models/resources_model.dart';
import 'package:breathpacer/layers/domain/use_cases/database/get_playlist_meditations_use_case.dart';
import 'package:breathpacer/layers/domain/use_cases/database/get_resources_use_case.dart';
import 'package:breathpacer/layers/presentation/views/pages/resources/resources_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/globals.dart';

class ResourcesViewModel extends Cubit<ResourcesState> {
  ResourcesViewModel() : super(ResourcesState()) {
    populateResourcesList();
  }

  List<ResourcesModel> allResourcesList = [];
  GetResourcesUseCase getResourcesUseCase = GetResourcesUseCase();
  GetPlaylistMeditations getPlaylistMeditations = GetPlaylistMeditations();

  Future<void> populateResourcesList() async {
    state.isLoading = true;
    emit(ResourcesState.clone(state));
    try {
      final token = await globalGetToken();
      final blogsIW = await getResourcesUseCase.execute(token!, "iw");
      final blogsWorkshop = await getResourcesUseCase.execute(token, "workshop");
      allResourcesList.addAll(blogsIW);
      allResourcesList.addAll(blogsWorkshop);
      state.resourceList = allResourcesList;
    } catch (e) {
      state.showErrorMessage = true;
      print("Failed to fetch resources: $e");
    }
    state.isLoading = false;
    emit(ResourcesState.clone(state));
  }

  Future<List<AudioSectionModel>> getAudios(int id) async {
    state.isLoading = true;
    emit(ResourcesState.clone(state));
    try {
      final token = await globalGetToken();
      final audios = await getPlaylistMeditations.execute(token!, id);
      return audios;
    } catch (e) {
      state.showErrorMessage = true;
      print("Failed to fetch resources: $e");
    }
    state.isLoading = false;
    emit(ResourcesState.clone(state));
    return [];
  }

  void filterResourceList(String category) {
    state.selectedCategory = category;
    if (category == "All") {
      state.resourceList = allResourcesList;
    } else if (category == "Workshops") {
      state.resourceList = allResourcesList.where((resource) {
        return resource.category.toLowerCase().contains("workshop");
      }).toList();
    } else if (category == "Infinite Wisdom") {
      state.resourceList = allResourcesList.where((resource) {
        return resource.category.toLowerCase().contains("iw");
      }).toList();
    }

    state.categories.remove(category);
    state.categories.insert(0, category);
    emit(ResourcesState.clone(state));
  }

  void reset() {
    emit(ResourcesState());
  }
}
