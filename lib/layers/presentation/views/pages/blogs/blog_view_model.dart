import 'package:breathpacer/layers/domain/use_cases/database/get_blogs_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blog_state.dart';

class BlogViewModel extends Cubit<BlogState> {
  BlogViewModel() : super(BlogState()) {
    populateBlogList();
  }

  GetBlogsUseCase getBlogsUseCase = GetBlogsUseCase();

  Future<void> populateBlogList() async {
    state.isLoading = true;
    emit(BlogState.clone(state));
    try {
      final blogs = await getBlogsUseCase.execute("post");
      state.blogList = blogs;
    } catch (e) {
      state.showErrorMessage = true;
      print("Failed to fetch blogs: $e");
    }
    state.isLoading = false;
    emit(BlogState.clone(state));
  }

  void reset() {
    emit(BlogState());
  }
}
