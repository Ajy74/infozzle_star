import '../../../../domain/models/video_model.dart';

class YogaState {
  List<VideoModel> videoList;
  String currentSearchText;
  bool showErrorMessage;
  bool isLoading;

  YogaState(
      {this.videoList = const [], this.currentSearchText = "", this.isLoading = false, this.showErrorMessage = false});

  YogaState.clone(YogaState existingState)
      : this(
            videoList: existingState.videoList,
            isLoading: existingState.isLoading,
            currentSearchText: existingState.currentSearchText,
            showErrorMessage: existingState.showErrorMessage);
}
