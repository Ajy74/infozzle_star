import 'package:breathpacer/layers/domain/services/database_fetch_service.dart';
import 'package:get/get.dart';

import '../../models/audio_section_model.dart';

class GetPlaylistMeditations {
  Future<List<AudioSectionModel>> execute(String token, int playlistId) async {
    return await Get.find<DatabaseFetchService>().getPlaylistMeditations(token, playlistId);
  }
}
