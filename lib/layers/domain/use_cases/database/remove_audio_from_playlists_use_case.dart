import 'package:breathpacer/layers/domain/services/database_fetch_service.dart';
import 'package:get/get.dart';

class RemoveAudioFromPlaylistUseCase {
  Future<void> execute(int audioID, List<int> playlistIDs, String token) async {
    return await Get.find<DatabaseFetchService>().removeAudiosFromPlaylists(audioID, playlistIDs, token);
  }
}
