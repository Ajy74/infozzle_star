import 'package:breathpacer/layers/domain/services/database_fetch_service.dart';
import 'package:get/get.dart';

import '../../models/audio_section_model.dart';

class UpdateAudioUseCase {
  Future<List<AudioSectionModel>> execute(String token, List<AudioSectionModel> oldAudios, int playlistId) async {
    return await Get.find<DatabaseFetchService>().updateAudioList(token, oldAudios, playlistId);
  }
}
