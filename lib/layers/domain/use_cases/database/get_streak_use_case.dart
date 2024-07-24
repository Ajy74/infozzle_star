import 'package:breathpacer/layers/domain/models/streak_model.dart';
import 'package:breathpacer/layers/domain/services/database_fetch_service.dart';
import 'package:get/get.dart';

class GetStreakUseCase {
  Future<StreakModel> execute(String token) async {
    return await Get.find<DatabaseFetchService>().getStreak(token);
  }
}
