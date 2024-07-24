import 'package:breathpacer/layers/domain/services/database_fetch_service.dart';
import 'package:get/get.dart';

class DeletePlaylistUseCase {
  Future<void> execute(int id, String token) async {
    return await Get.find<DatabaseFetchService>().deletePlaylist(id, token);
  }
}
