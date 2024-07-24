import 'package:breathpacer/helpers/enums/breathing_enum.dart';

class BreathingExerciseModel {
  final String title;
  final BreathingIconEnum icon;
  final String iconDescription;
  final List<String> difficulties;

  const BreathingExerciseModel(
      {required this.title, required this.icon, required this.difficulties, required this.iconDescription});
}
