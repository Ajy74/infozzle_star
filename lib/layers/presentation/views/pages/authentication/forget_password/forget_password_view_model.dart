import 'package:breathpacer/layers/presentation/views/pages/authentication/forget_password/forget_password_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgetPasswordViewModel extends Cubit<ForgetPasswordState> {
  ForgetPasswordViewModel() : super(ForgetPasswordState());
  final TextEditingController emailController = TextEditingController();

  void reset() {
    emit(ForgetPasswordState());
  }
}
