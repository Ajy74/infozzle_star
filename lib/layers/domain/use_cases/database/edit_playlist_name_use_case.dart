import 'package:breathpacer/layers/domain/services/database_fetch_service.dart';
import 'package:get/get.dart';

class EditPlaylistNameUseCase {
  Future<void> execute(int id, String newName, String token) async {
    return await Get.find<DatabaseFetchService>().editPlaylistName(id, newName, token);
  }
}
