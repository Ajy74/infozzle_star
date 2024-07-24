import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../helpers/token_expiration.dart';
import '../../../domain/models/user_model.dart';
import '../../../domain/repository/user_repository.dart';

class UserRepositoryLaravel implements UserRepository {
  static const String apiURL = 'https://smhapi.testingweblink.com/api/';
  final String liveApiUrl = "https://api.starmagichealing.org/api/";

  @override
  Future<UserModel> getUser(String token) async {
    final response = await http.get(
      Uri.parse("${liveApiUrl}getuserinfo"),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['status'] == true) {
        return UserModel.fromJson(data);
      } else if (data['message'] == 'Token Expired!') {
        throw TokenExpiredException("Token Expired!");
      } else {
        throw Exception('Failed to load user');
      }
    } else {
      throw Exception('Failed to load user');
    }
  }

  @override
  Future<void> addUser(String id, String name, String email) {
    // TODO: implement addUser
    throw UnimplementedError();
  }
}
