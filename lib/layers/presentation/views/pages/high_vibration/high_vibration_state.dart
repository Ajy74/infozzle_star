import 'package:breathpacer/layers/domain/models/blog_model.dart';

class HighVibrationState {
  List<BlogModel> blogList;
  String currentSearchText;
  bool isLoading;
  bool showErrorMessage;

  HighVibrationState({
    this.blogList = const [],
    this.currentSearchText = "",
    this.isLoading = false,
    this.showErrorMessage = false,
  });

  HighVibrationState.clone(HighVibrationState existingState)
      : this(
            blogList: existingState.blogList,
            currentSearchText: existingState.currentSearchText,
            isLoading: existingState.isLoading,
            showErrorMessage: existingState.showErrorMessage);
}
