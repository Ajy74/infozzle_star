class VideoModel {
  final String title;
  final String videoURL;
  final String image;
  final String description;

  VideoModel({
    required this.title,
    required this.videoURL,
    required this.image,
    required this.description,
  });

  VideoModel copyWith({
    String? title,
    String? videoURL,
    String? image,
    String? description,
  }) {
    return VideoModel(
      title: title ?? this.title,
      videoURL: videoURL ?? this.videoURL,
      image: image ?? this.image,
      description: description ?? this.description,
    );
  }

  factory VideoModel.fromJson(Map<String, dynamic> json) {
    return VideoModel(
      title: json['title'],
      videoURL: json['url'],
      image: json['thumbnail'],
      description: json['description'] ?? '',
    );
  }

  static List<VideoModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => VideoModel.fromJson(json)).toList();
  }
}
