import 'package:breathpacer/layers/presentation/views/pages/authentication/login/login_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../domain/use_cases/authentication/login_use_case.dart';

class LoginViewmodel extends Cubit<LoginState> {
  LoginViewmodel() : super(LoginState());
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final LoginUseCase loginUseCase = LoginUseCase();

  Future<void> login({required Function onSuccess, required Function(String) onError}) async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      state.isEmpty = true;
      emit(LoginState.clone(state));
    } else {
      state.isEmpty = false;
      emit(LoginState.clone(state));
    }

    try {
      final user = await loginUseCase.execute(emailController.text, passwordController.text);
      print('Logged in as ${user.name}');
      onSuccess();
    } catch (e) {
      print("Failed to login: $e");
      onError(e.toString());
    }
  }

  void reset() {
    emit(LoginState());
  }
}
