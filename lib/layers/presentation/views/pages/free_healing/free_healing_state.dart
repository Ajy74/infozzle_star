import '../../../../domain/models/video_model.dart';

class FreeHealingState {
  List<VideoModel> videoList;

  FreeHealingState({
    this.videoList = const [],
  });

  FreeHealingState.clone(FreeHealingState existingState)
      : this(
          videoList: existingState.videoList,
        );
}
