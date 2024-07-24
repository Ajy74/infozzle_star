import 'package:breathpacer/layers/domain/models/video_model.dart';
import 'package:breathpacer/layers/domain/services/database_fetch_service.dart';
import 'package:get/get.dart';

class GetYogaVideosUseCase {
  Future<List<VideoModel>> execute(String token) async {
    return await Get.find<DatabaseFetchService>().fetchYogaVideos(token);
  }
}
