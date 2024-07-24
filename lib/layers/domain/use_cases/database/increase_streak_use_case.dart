import 'package:breathpacer/layers/domain/services/database_fetch_service.dart';
import 'package:get/get.dart';

class IncreaseStreakUseCase {
  Future<String> execute(String token) async {
    return await Get.find<DatabaseFetchService>().increaseStreak("UTC", token);
  }
}
