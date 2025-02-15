import 'package:breathpacer/layers/domain/services/database_fetch_service.dart';
import 'package:get/get.dart';

class RemoveLikeUseCase {
  Future<void> execute(int libraryID, String token) async {
    return await Get.find<DatabaseFetchService>().removeLike(libraryID, token);
  }
}
