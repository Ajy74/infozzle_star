import 'package:breathpacer/layers/domain/services/database_fetch_service.dart';
import 'package:get/get.dart';

class AddAudioToPlaylistUseCase {
  Future<void> execute(int audioID, int playlistID, String token) async {
    return await Get.find<DatabaseFetchService>().addAudioToPlaylist(audioID, playlistID, token);
  }
}
