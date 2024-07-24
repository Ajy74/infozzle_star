import 'package:breathpacer/layers/domain/models/meditation_model.dart';
import 'package:breathpacer/layers/domain/services/database_fetch_service.dart';
import 'package:get/get.dart';

class GetAllMeditationsUseCase {
  Future<List<MeditationModel>> execute(bool ignoreCache) async {
    return await Get.find<DatabaseFetchService>().fetchAllMeditations(ignoreCache);
  }
}
