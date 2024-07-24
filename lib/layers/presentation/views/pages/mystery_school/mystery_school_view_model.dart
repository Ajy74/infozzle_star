import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/use_cases/database/get_blogs_use_case.dart';
import 'mystery_school_state.dart';

class MysterySchoolViewModel extends Cubit<MysterySchoolState> {
  MysterySchoolViewModel() : super(MysterySchoolState()) {
    populateBlogList();
  }

  GetBlogsUseCase getBlogsUseCase = GetBlogsUseCase();

  Future<void> populateBlogList() async {
    state.isLoading = true;
    emit(MysterySchoolState.clone(state));
    try {
      final blogs = await getBlogsUseCase.execute("inspire");
      state.blogs = blogs;
    } catch (e) {
      state.showErrorMessage = true;
      print("Failed to fetch blogs: $e");
    }
    state.isLoading = false;
    emit(MysterySchoolState.clone(state));
  }

  void reset() {
    emit(MysterySchoolState());
  }
}
