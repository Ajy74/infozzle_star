import 'package:breathpacer/layers/domain/models/blog_model.dart';
import 'package:breathpacer/layers/presentation/views/pages/high_vibration/high_vibration_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/use_cases/database/get_blogs_use_case.dart';

class HighVibrationViewModel extends Cubit<HighVibrationState> {
  HighVibrationViewModel() : super(HighVibrationState()) {
    populateBlogList();
  }

  final SearchController controller = SearchController();
  List<BlogModel> _allFoodList = [];

  GetBlogsUseCase getBlogsUseCase = GetBlogsUseCase();

  Future<void> populateBlogList() async {
    state.isLoading = true;
    emit(HighVibrationState.clone(state));
    try {
      final blogs = await getBlogsUseCase.execute("nutrition");
      _allFoodList = blogs;
      state.blogList = _allFoodList;
    } catch (e) {
      state.showErrorMessage = true;
      print("Failed to fetch blogs: $e");
    }
    state.isLoading = false;
    emit(HighVibrationState.clone(state));
  }

  void filterFoodList(String searchText) {
    if (searchText.isEmpty) {
      state.blogList = _allFoodList;
    } else {
      state.blogList = _allFoodList.where((audio) {
        return audio.title.toLowerCase().contains(searchText.toLowerCase());
      }).toList();
    }
  }

  void updateSearchText() {
    state.currentSearchText = controller.text;
    filterFoodList(state.currentSearchText);
    emit(HighVibrationState.clone(state));
  }

  void reset() {
    emit(HighVibrationState());
  }
}
