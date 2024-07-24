import '../../../../domain/models/leaderboard_model.dart';

class LeaderboardState {
  List<LeaderboardModel> leaderboard;
  bool showErrorMessage;
  bool isLoading;

  LeaderboardState({
    this.leaderboard = const [],
    this.isLoading = false,
    this.showErrorMessage = false,
  });

  LeaderboardState.clone(LeaderboardState existingState)
      : this(
            leaderboard: existingState.leaderboard,
            isLoading: existingState.isLoading,
            showErrorMessage: existingState.showErrorMessage);
}
