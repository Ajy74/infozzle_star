import 'package:breathpacer/layers/domain/services/database_fetch_service.dart';
import 'package:get/get.dart';

import '../../models/audio_section_model.dart';

class GetSingleAudioUseCase {
  Future<AudioSectionModel> execute(String libraryId, String token) async {
    return await Get.find<DatabaseFetchService>().getSingleAudioInfo(libraryId, token);
  }
}
