import 'light_language_audio.dart';

class VaultsModel {
  final String title;
  final List<LightLanguageAudioModel> audios;

  const VaultsModel({required this.title, required this.audios});

  VaultsModel copyWith({
    String? title,
    List<LightLanguageAudioModel>? audios,
  }) {
    return VaultsModel(
      title: title ?? this.title,
      audios: audios ?? this.audios,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'audios': audios.map((audio) => audio.toJson()).toList(),
    };
  }

  factory VaultsModel.fromJson(Map<String, dynamic> json) {
    return VaultsModel(
      title: json['title'],
      audios: (json['audios'] as List).map((audio) => LightLanguageAudioModel.fromJson(audio)).toList(),
    );
  }

  static List<VaultsModel> fromJsonList(dynamic json) {
    if (json is List) {
      return json.map((item) => VaultsModel.fromJson(item)).toList();
    } else {
      throw Exception('Invalid JSON format');
    }
  }
}
