import '../models/user_model.dart';

abstract class AuthenticationService {
  Future<UserModel> register(String name, String password);
  Future<UserModel> login(String username, String password);
  Future<void> resetPassword(String email);
  void logout();
}
