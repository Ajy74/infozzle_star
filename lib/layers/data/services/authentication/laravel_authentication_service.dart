import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../../domain/models/user_model.dart';
import '../../../domain/services/authentication_service.dart';

class LaravelAuthenticationService implements AuthenticationService {
  final String liveApiUrl = "https://api.starmagichealing.org/api/";

  @override
  Future<UserModel> login(String username, String password) async {
    final response = await http.post(
      Uri.parse("${liveApiUrl}login"),
      body: {
        'username': username,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final userModel = UserModel.fromJson(data);

      // Save data locally
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', data['token']);
      await prefs.setInt('tokenExpires', data['token_expires']);
      return userModel;
    } else {
      throw Exception('Failed to login');
    }
  }

  @override
  void logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await prefs.remove('tokenExpires');
  }

  @override
  Future<UserModel> register(String name, String password) {
    // TODO: implement register
    throw UnimplementedError();
  }

  @override
  Future<void> resetPassword(String email) {
    // TODO: implement resetPassword
    throw UnimplementedError();
  }
}
