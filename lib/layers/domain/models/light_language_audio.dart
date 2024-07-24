class LightLanguageAudioModel {
  final int id;
  final String title;
  final String image;
  final String audioURL;
  final String originalURL;
  final bool isDownloaded;
  final String downloadedAt;
  final bool isAddedToPlaylist;
  final List<String> savedInPlaylists;
  final List<String> savedInVaults;

  const LightLanguageAudioModel({
    required this.id,
    required this.title,
    required this.image,
    required this.audioURL,
    required this.originalURL,
    required this.isDownloaded,
    required this.downloadedAt,
    required this.isAddedToPlaylist,
    required this.savedInPlaylists,
    required this.savedInVaults,
  });

  LightLanguageAudioModel copyWith({
    String? title,
    String? image,
    String? audioURL,
    String? originalURL,
    bool? isDownloaded,
    String? downloadedAt,
    bool? isAddedToPlaylist,
    List<String>? savedInPlaylists,
    List<String>? savedInVaults,
    int? id,
  }) {
    return LightLanguageAudioModel(
      title: title ?? this.title,
      image: image ?? this.image,
      audioURL: audioURL ?? this.audioURL,
      originalURL: originalURL ?? this.originalURL,
      isDownloaded: isDownloaded ?? this.isDownloaded,
      downloadedAt: downloadedAt ?? this.downloadedAt,
      isAddedToPlaylist: isAddedToPlaylist ?? this.isAddedToPlaylist,
      savedInPlaylists: savedInPlaylists ?? this.savedInPlaylists,
      savedInVaults: savedInVaults ?? this.savedInVaults,
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'image': image,
      'audio_file': audioURL,
      'originalURL': originalURL,
      'isDownloaded': isDownloaded,
      'downloadedAt': downloadedAt,
      'isAddedToPlaylist': isAddedToPlaylist,
      'savedInPlaylists': savedInPlaylists,
      'savedInVaults': savedInVaults,
    };
  }

  factory LightLanguageAudioModel.fromJson(Map<String, dynamic> json) {
    return LightLanguageAudioModel(
      id: json['id'],
      title: json['title'],
      image: json['image'],
      audioURL: json['audio_file'],
      originalURL: json['audio_file'],
      isDownloaded: false,
      downloadedAt: '',
      isAddedToPlaylist: false,
      savedInPlaylists: [],
      savedInVaults: [],
    );
  }

  static List<LightLanguageAudioModel> fromJsonList(dynamic json) {
    if (json is List) {
      return json.map((item) => LightLanguageAudioModel.fromJson(item)).toList();
    } else if (json is Map<String, dynamic> && json.containsKey('data')) {
      final List<dynamic> dataList = json['data'];
      return dataList.map((item) => LightLanguageAudioModel.fromJson(item)).toList();
    } else {
      throw Exception('Invalid JSON format');
    }
  }
}
