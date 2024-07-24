class AudioSectionModel {
  final int id;
  final String title;
  final String image;
  final String time;
  final String description;
  final String audioURL;
  final String originalURL;
  final int numOfLikes;
  final bool isDownloaded;
  final bool isLiked;
  final bool unlocked;
  final bool isAddedToPlaylist;
  final List<String> savedInPlaylists;
  final List<String> savedInVaults;

  AudioSectionModel({
    required this.id,
    required this.title,
    required this.image,
    required this.time,
    required this.description,
    required this.audioURL,
    required this.originalURL,
    required this.isDownloaded,
    required this.isLiked,
    required this.unlocked,
    required this.isAddedToPlaylist,
    required this.numOfLikes,
    required this.savedInPlaylists,
    required this.savedInVaults,
  });

  AudioSectionModel copyWith({
    int? id,
    String? title,
    String? image,
    String? time,
    String? description,
    String? audioURL,
    String? originalURL,
    bool? isDownloaded,
    bool? isLiked,
    bool? unlocked,
    bool? isAddedToPlaylist,
    int? numOfLikes,
    List<String>? savedInPlaylists,
    List<String>? savedInVaults,
  }) {
    return AudioSectionModel(
      id: id ?? this.id,
      title: title ?? this.title,
      image: image ?? this.image,
      time: time ?? this.time,
      description: description ?? this.description,
      audioURL: audioURL ?? this.audioURL,
      originalURL: originalURL ?? this.originalURL,
      isDownloaded: isDownloaded ?? this.isDownloaded,
      isLiked: isLiked ?? this.isLiked,
      unlocked: unlocked ?? this.unlocked,
      isAddedToPlaylist: isAddedToPlaylist ?? this.isAddedToPlaylist,
      numOfLikes: numOfLikes ?? this.numOfLikes,
      savedInPlaylists: savedInPlaylists ?? this.savedInPlaylists,
      savedInVaults: savedInVaults ?? this.savedInVaults,
    );
  }

  factory AudioSectionModel.fromJson(Map<String, dynamic> json) {
    return AudioSectionModel(
      id: json['id'] is String ? int.tryParse(json['id']) ?? 0 : json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      numOfLikes: json['likeCount'] is String ? int.tryParse(json['likeCount']) ?? 0 : json['likeCount'] ?? 0,
      isLiked: json['liked'] ?? false,
      unlocked: json['unlocked'] ?? false,
      audioURL: json['audio_file'] ?? '',
      originalURL: json['audio_file'] ?? '',
      time: json['duration'] ?? '',
      image: json['poster_image'] ?? '',
      isDownloaded: false,
      isAddedToPlaylist: false,
      savedInPlaylists: [],
      savedInVaults: [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'poster_image': image,
      'duration': time,
      'description': description,
      'audio_file': audioURL,
      'liked': isLiked,
      'unlocked': unlocked,
      'likeCount': numOfLikes,
      'isDownloaded': isDownloaded,
      'isAddedToPlaylist': isAddedToPlaylist,
      'savedInPlaylists': savedInPlaylists,
      'savedInVaults': savedInVaults,
    };
  }

  static List<AudioSectionModel> fromJsonList(dynamic json) {
    if (json is List) {
      return json.map((item) => AudioSectionModel.fromJson(item)).toList();
    } else {
      throw Exception('Invalid JSON format');
    }
  }
}
