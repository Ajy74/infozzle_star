import 'audio_section_model.dart';

class ChallengeModel {
  final String title;
  final String description;
  final List<AudioSectionModel> challenges;

  const ChallengeModel({
    required this.title,
    required this.description,
    required this.challenges,
  });

  ChallengeModel copyWith({
    String? title,
    String? description,
    List<AudioSectionModel>? challenges,
  }) {
    return ChallengeModel(
      title: title ?? this.title,
      description: description ?? this.description,
      challenges: challenges ?? this.challenges,
    );
  }
}
