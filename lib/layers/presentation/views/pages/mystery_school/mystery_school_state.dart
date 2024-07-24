import '../../../../domain/models/blog_model.dart';

class MysterySchoolState {
  List<BlogModel> blogs;
  bool isLoading;
  bool showErrorMessage;

  MysterySchoolState({
    this.blogs = const [],
    this.isLoading = false,
    this.showErrorMessage = false,
  });

  MysterySchoolState.clone(MysterySchoolState existingState)
      : this(
            blogs: existingState.blogs,
            isLoading: existingState.isLoading,
            showErrorMessage: existingState.showErrorMessage);
}
