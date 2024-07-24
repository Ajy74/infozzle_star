import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/models/video_model.dart';
import 'free_healing_state.dart';

class FreeHealingViewModel extends Cubit<FreeHealingState> {
  FreeHealingViewModel() : super(FreeHealingState()) {
    populateVideoList();
  }

  void populateVideoList() {
    List<VideoModel> allVideoList = [
      VideoModel(
          title: "Big Buck Bunny",
          videoURL:
              "https://player.vimeo.com/progressive_redirect/playback/718725263/rendition/1080p/file.mp4?loc=external&oauth2_token_id=1752096022&signature=a6e7d58e2c226ac631eb273d719d8209c333bcece807255ed4da7d55594bf28b",
          image: "https://illudiumfilm.com/big_buck_bunny_title_658w.jpg",
          description: ""),
      VideoModel(
          title: "HERO – Blender Grease Pencil showcase",
          videoURL:
              "https://player.vimeo.com/progressive_redirect/playback/718725263/rendition/1080p/file.mp4?loc=external&oauth2_token_id=1752096022&signature=a6e7d58e2c226ac631eb273d719d8209c333bcece807255ed4da7d55594bf28b",
          image: "https://i.ytimg.com/vi/pKmSdY56VtY/maxresdefault.jpg",
          description: "")
    ];

    state.videoList = allVideoList;
    emit(FreeHealingState.clone(state));
  }

  void reset() {
    emit(FreeHealingState());
  }

// Future<String?> getThumbnail(String videoURL) async{
//   final fileName =  VideoThumbnail.thumbnailFile(
//     video: videoURL,
//     thumbnailPath: (await getTemporaryDirectory()).path,
//     imageFormat: ImageFormat.WEBP,
//     maxHeight: 64,
//     quality: 75,
//   );
//
//   return fileName;
// }
}
