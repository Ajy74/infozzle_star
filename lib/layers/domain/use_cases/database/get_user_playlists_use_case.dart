import 'package:breathpacer/layers/domain/models/playlist_model.dart';
import 'package:breathpacer/layers/domain/services/database_fetch_service.dart';
import 'package:get/get.dart';

class GetUserPlaylistsUseCase {
  Future<List<PlaylistItem>> execute(String token) async {
    return await Get.find<DatabaseFetchService>().getUserPlaylists(token);
  }
}
