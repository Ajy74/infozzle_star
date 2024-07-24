import 'package:breathpacer/layers/domain/use_cases/database/get_leaderboards_use_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/globals.dart';
import 'leaderboard_state.dart';

class LeaderboardViewModel extends Cubit<LeaderboardState> {
  LeaderboardViewModel() : super(LeaderboardState()) {
    fetchLeaderboard();
  }

  GetLeaderboardsUseCase getLeaderboardsUseCase = GetLeaderboardsUseCase();

  Future fetchLeaderboard() async {
    state.isLoading = true;
    emit(LeaderboardState.clone(state));
    try {
      final token = await globalGetToken();
      final newLeaderboard = await getLeaderboardsUseCase.execute(token!);
      state.leaderboard = newLeaderboard;
    } catch (e) {
      state.showErrorMessage = true;
      print("Failed to fetch leaderboards: $e");
    }
    state.isLoading = false;
    emit(LeaderboardState.clone(state));
  }

  void reset() {
    emit(LeaderboardState());
  }
}
