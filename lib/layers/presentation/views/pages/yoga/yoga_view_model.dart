import 'package:breathpacer/layers/domain/use_cases/database/get_yoga_videos_use_case.dart';
import 'package:breathpacer/layers/presentation/views/pages/yoga/yoga_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/globals.dart';
import '../../../../domain/models/video_model.dart';

class YogaViewModel extends Cubit<YogaState> {
  YogaViewModel() : super(YogaState()) {
    populateVideoList();
  }

  final TextEditingController controller = TextEditingController();
  GetYogaVideosUseCase getYogaVideosUseCase = GetYogaVideosUseCase();
  List<VideoModel> allVideosList = [];

  Future<void> populateVideoList() async {
    state.isLoading = true;
    emit(YogaState.clone(state));

    try {
      final token = await globalGetToken();
      final videos = await getYogaVideosUseCase.execute(token!);
      allVideosList = videos;
      state.videoList = allVideosList;
    } catch (e) {
      state.showErrorMessage = true;
      print("Failed to fetch yoga videos $e");
    }
    state.isLoading = false;
    emit(YogaState.clone(state));
  }

  void filterVideoList(String searchText) {
    if (searchText.isEmpty) {
      state.videoList = allVideosList;
    } else {
      state.videoList = allVideosList.where((video) {
        return video.title.toLowerCase().contains(searchText.toLowerCase());
      }).toList();
    }
    emit(YogaState.clone(state));
  }

  void updateSearchText(String searchText) {
    state.currentSearchText = searchText;
    filterVideoList(state.currentSearchText);
  }
}
