import 'package:breathpacer/layers/domain/services/database_fetch_service.dart';
import 'package:get/get.dart';

class GetDashboardUseCase {
  Future<String> execute(String token) async {
    return await Get.find<DatabaseFetchService>().getDashboard(token);
  }
}
