import 'package:breathpacer/layers/domain/models/audio_section_model.dart';

class PlaylistModel {
  final int id;
  final String title;
  final List<PlaylistItem> audios;

  const PlaylistModel({required this.id, required this.title, required this.audios});

  PlaylistModel copyWith({
    int? id,
    String? title,
    List<PlaylistItem>? audios,
  }) {
    return PlaylistModel(
      id: id ?? this.id,
      title: title ?? this.title,
      audios: audios ?? this.audios,
    );
  }

  factory PlaylistModel.fromJson(Map<String, dynamic> json, List<PlaylistItem> audios) {
    return PlaylistModel(
      id: json['term_id'],
      title: json['name'],
      audios: audios,
    );
  }

  static List<PlaylistModel> fromJsonList(List<dynamic> jsonList, List<List<PlaylistItem>> audiosList) {
    return jsonList
        .asMap()
        .map((index, json) => MapEntry(index, PlaylistModel.fromJson(json, audiosList[index])))
        .values
        .toList();
  }
}

class PlaylistItem {
  final int id;
  final String title;
  final String description;
  final String image;
  final List<AudioSectionModel> audios;

  const PlaylistItem({
    required this.id,
    required this.title,
    required this.image,
    required this.description,
    required this.audios,
  });

  factory PlaylistItem.fromJson(Map<String, dynamic> json, List<AudioSectionModel> audios) {
    return PlaylistItem(
      id: json['playlist_id'] ?? json['id'] ?? 0,
      description: '',
      image: json['image'] ?? '',
      title: json['name'],
      audios: audios,
    );
  }

  static List<PlaylistItem> fromJsonList(dynamic json, List<List<AudioSectionModel>> audiosList) {
    if (json is List) {
      return json
          .asMap()
          .map((index, item) => MapEntry(index, PlaylistItem.fromJson(item, audiosList[index])))
          .values
          .toList();
    } else {
      throw Exception('Invalid JSON format');
    }
  }
}
