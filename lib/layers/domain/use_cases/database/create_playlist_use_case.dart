import 'package:breathpacer/layers/domain/services/database_fetch_service.dart';
import 'package:get/get.dart';

class CreatePlaylistUseCase {
  Future<void> execute(String name, String token) async {
    return await Get.find<DatabaseFetchService>().createPlaylist(name, token);
  }
}
