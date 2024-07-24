class StreakModel {
  final bool hasStreak;
  final int streak;
  final String? startStreakDate;
  final String? lastStreakDate;

  StreakModel({
    required this.hasStreak,
    required this.streak,
    required this.startStreakDate,
    required this.lastStreakDate,
  });

  factory StreakModel.fromJson(Map<String, dynamic> json) {
    return StreakModel(
      hasStreak: json['status'],
      streak: json['streak'],
      startStreakDate: json['start_streaked_at'] ?? '',
      lastStreakDate: json['last_streaked_at'] ?? '',
    );
  }
}
