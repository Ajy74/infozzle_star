import 'package:breathpacer/layers/presentation/views/pages/streak/streak_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/globals.dart';
import '../../../../domain/models/streak_model.dart';
import '../../../../domain/use_cases/database/get_streak_use_case.dart';

class StreakViewModel extends Cubit<StreakState> {
  StreakViewModel() : super(StreakState()) {
    getStreak();
  }

  GetStreakUseCase getStreakUseCase = GetStreakUseCase();

  Future<void> getStreak() async {
    try {
      final token = await globalGetToken();
      final model = await getStreakUseCase.execute(token!);
      calculateStreak(model);
    } catch (e) {
      state.showErrorMessage = true;
      print("Failed to get streak: $e");
    }
    emit(StreakState.clone(state));
  }

  void calculateStreak(StreakModel model) {
    DateTime startStreakDate = DateTime.parse(model.startStreakDate ?? "");
    List<String> fullStreakDays = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"];

    int streak = model.streak;
    DateTime now = DateTime.now();
    Duration difference = now.difference(startStreakDate);
    int streakDays = (difference.inDays).floor() + 1;
    if (streakDays > 0) {
      streak = streakDays;
    }

    int startDayIndex = startStreakDate.weekday - 1;
    List<String> streakDaysList = [];
    for (int i = 0; i < streak; i++) {
      streakDaysList.add(fullStreakDays[(startDayIndex + i) % 7]);
    }

    if (streakDaysList.length > 7) {
      streakDaysList = streakDaysList.sublist(streakDaysList.length - 7);
    }

    state.streakDays = streakDaysList;
    state.currentStreak = streak;

    emit(StreakState.clone(state));
  }

  void reset() {
    emit(StreakState());
  }
}
