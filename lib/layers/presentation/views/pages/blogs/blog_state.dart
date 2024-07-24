import 'package:breathpacer/layers/domain/models/blog_model.dart';

class BlogState {
  List<BlogModel> blogList;
  bool showErrorMessage;
  bool isLoading;

  BlogState({
    this.blogList = const [],
    this.showErrorMessage = false,
    this.isLoading = false,
  });

  BlogState.clone(BlogState existingState)
      : this(
            showErrorMessage: existingState.showErrorMessage,
            blogList: existingState.blogList,
            isLoading: existingState.isLoading);
}
