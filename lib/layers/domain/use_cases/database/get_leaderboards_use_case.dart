import 'package:breathpacer/layers/domain/models/leaderboard_model.dart';
import 'package:breathpacer/layers/domain/services/database_fetch_service.dart';
import 'package:get/get.dart';

class GetLeaderboardsUseCase {
  Future<List<LeaderboardModel>> execute(String token) async {
    return await Get.find<DatabaseFetchService>().getLeaderboards(token);
  }
}
