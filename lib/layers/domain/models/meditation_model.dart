import 'audio_section_model.dart';

class MeditationModel {
  final String playlistId;
  final String title;
  final List<AudioSectionModel> audios;

  const MeditationModel({
    required this.playlistId,
    required this.title,
    required this.audios,
  });

  MeditationModel copyWith({
    String? playlistId,
    String? title,
    List<AudioSectionModel>? audios,
  }) {
    return MeditationModel(
      title: title ?? this.title,
      audios: audios ?? this.audios,
      playlistId: playlistId ?? this.playlistId,
    );
  }

  factory MeditationModel.fromJson(Map<String, dynamic> json) {
    return MeditationModel(
      playlistId: json['playlist_id'],
      title: json['playlist_name'],
      audios: AudioSectionModel.fromJsonList(json['audio_list']),
    );
  }

  static List<MeditationModel> fromJsonList(dynamic json) {
    if (json is List) {
      return json.map((item) => MeditationModel.fromJson(item)).toList();
    } else if (json is Map<String, dynamic> && json.containsKey('data')) {
      final List<dynamic> dataList = json['data'];
      return dataList.map((item) => MeditationModel.fromJson(item)).toList();
    } else {
      throw Exception('Invalid JSON format');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'playlist_id': playlistId,
      'playlist_name': title,
      'audio_list': audios.map((audio) => audio.toJson()).toList(),
    };
  }
}
