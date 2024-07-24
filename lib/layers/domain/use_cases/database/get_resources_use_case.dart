import 'package:breathpacer/layers/domain/models/resources_model.dart';
import 'package:breathpacer/layers/domain/services/database_fetch_service.dart';
import 'package:get/get.dart';

class GetResourcesUseCase {
  Future<List<ResourcesModel>> execute(String token, String type) async {
    return await Get.find<DatabaseFetchService>().getResources(token, type);
  }
}
