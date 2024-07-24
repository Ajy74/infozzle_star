import 'audio_section_model.dart';

class ResourcesModel {
  final int id;
  final String title;
  final String category;
  final String image;
  final List<AudioSectionModel> resources;
  final bool isActive;

  const ResourcesModel({
    required this.id,
    required this.title,
    required this.category,
    required this.resources,
    required this.image,
    required this.isActive,
  });

  ResourcesModel copyWith({
    int? id,
    String? title,
    String? category,
    String? image,
    List<AudioSectionModel>? resources,
    bool? isActive,
  }) {
    return ResourcesModel(
        id: id ?? this.id,
        title: title ?? this.title,
        image: image ?? this.image,
        category: category ?? this.category,
        resources: resources ?? this.resources,
        isActive: isActive ?? this.isActive);
  }

  factory ResourcesModel.fromJson(Map<String, dynamic> json, String category) {
    return ResourcesModel(
      id: json['id'],
      category: category,
      title: json['name'],
      image: json['image'],
      isActive: json['role_id'],
      resources: [],
    );
  }
}
