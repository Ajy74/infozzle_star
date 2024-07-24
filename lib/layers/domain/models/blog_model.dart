class BlogModel {
  final int id;
  final String title;
  final String videoID;
  final String image;
  final String description;
  final String transcript;

  BlogModel(
      {required this.id,
      required this.title,
      required this.videoID,
      required this.image,
      required this.description,
      required this.transcript});

  BlogModel copyWith({
    int? id,
    String? title,
    String? videoID,
    String? image,
    String? description,
    String? transcript,
  }) {
    return BlogModel(
      id: id ?? this.id,
      title: title ?? this.title,
      videoID: videoID ?? this.videoID,
      image: image ?? this.image,
      description: description ?? this.description,
      transcript: transcript ?? this.transcript,
    );
  }

  factory BlogModel.fromJson(Map<String, dynamic> json) {
    return BlogModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      image: json['image'] ?? '',
      videoID: json['audio_file'] ?? '',
      transcript: json["post_excerpt"] ?? '',
    );
  }

  static List<BlogModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => BlogModel.fromJson(json)).toList();
  }
}
