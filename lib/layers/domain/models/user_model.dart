class UserModel {
  final String id;
  final String? name;
  final String? email;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['user_id'].toString(),
      name: json['user_display_name'],
      email: json['user_email'],
    );
  }
}
