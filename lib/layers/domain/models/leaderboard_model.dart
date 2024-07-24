class LeaderboardModel {
  final String userName;
  final String score;

  LeaderboardModel({
    required this.userName,
    required this.score,
  });

  LeaderboardModel copyWith({
    String? userName,
    String? score,
  }) {
    return LeaderboardModel(
      userName: userName ?? this.userName,
      score: score ?? this.score,
    );
  }

  factory LeaderboardModel.fromJson(Map<String, dynamic> json) {
    return LeaderboardModel(
      userName: json['display_name'] ?? '',
      score: json['transmissions'] ?? '0',
    );
  }
}
