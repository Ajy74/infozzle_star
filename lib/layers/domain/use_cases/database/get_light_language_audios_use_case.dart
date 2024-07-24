import 'package:breathpacer/layers/domain/models/light_language_audio.dart';
import 'package:breathpacer/layers/domain/services/database_fetch_service.dart';
import 'package:get/get.dart';

class GetLightLanguageAudiosUseCase {
  Future<List<LightLanguageAudioModel>> execute(String token) async {
    return await Get.find<DatabaseFetchService>().fetchLightLanguageAudios(token);
  }
}
