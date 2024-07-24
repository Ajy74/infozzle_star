class StreakState {
  int currentStreak;
  List<String> streakDays;
  bool showErrorMessage;

  StreakState({
    this.currentStreak = 1,
    this.streakDays = const [],
    this.showErrorMessage = false,
  });

  StreakState.clone(StreakState existingState)
      : this(
            currentStreak: existingState.currentStreak,
            streakDays: existingState.streakDays,
            showErrorMessage: existingState.showErrorMessage);
}
