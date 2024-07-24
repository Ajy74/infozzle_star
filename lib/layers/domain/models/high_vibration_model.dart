class HighVibrationModel {
  final String title;
  final String image;
  final String shortMessage;
  final String servings;
  final String totalTime;
  final String ingredients;
  final String method;

  const HighVibrationModel({
    required this.title,
    required this.image,
    required this.shortMessage,
    required this.servings,
    required this.totalTime,
    required this.ingredients,
    required this.method,
  });

  HighVibrationModel copyWith({
    String? title,
    String? image,
    String? description,
    String? shortMessage,
    String? servings,
    String? totalTime,
    String? ingredients,
    String? method,
  }) {
    return HighVibrationModel(
      title: title ?? this.title,
      image: image ?? this.image,
      shortMessage: shortMessage ?? this.shortMessage,
      servings: servings ?? this.servings,
      totalTime: totalTime ?? this.totalTime,
      ingredients: ingredients ?? this.ingredients,
      method: method ?? this.method,
    );
  }
}
