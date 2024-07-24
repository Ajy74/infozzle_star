import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:breathpacer/layers/presentation/views/pages/authentication/login/login_state.dart';
import 'package:breathpacer/layers/presentation/views/pages/authentication/login/login_view_model.dart';
import 'package:breathpacer/layers/presentation/views/shared_widgets/star_magic/authentication_text_field.dart';
import 'package:breathpacer/layers/presentation/views/shared_widgets/star_magic/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../theme/app_theme.dart';

class LoginView extends StatelessWidget {
  LoginView({super.key});

  final LoginViewmodel viewModel = LoginViewmodel();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      decoration: BoxDecoration(gradient: AppTheme.colors.linearGradient),
      child: SafeArea(
        top: true,
        bottom: true,
        child: Scaffold(
          body: BlocBuilder<LoginViewmodel, LoginState>(
            bloc: viewModel,
            builder: (_, state) {
              return Stack(
                children: [
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'SIGN IN',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(height: 20),
                        AuthenticationTextField(
                            hint: 'Username or email address',
                            isEmail: true,
                            obscure: false,
                            controller: viewModel.emailController),
                        AuthenticationTextField(
                            hint: 'Password', obscure: true, controller: viewModel.passwordController),
                        const SizedBox(height: 25),
                        CustomButton(
                            buttonText: "Sign in",
                            color: AppTheme.colors.lightBlueButton,
                            onTap: () {
                              viewModel.login(
                                onSuccess: () {
                                  context.go("/home");
                                },
                                onError: (error) {
                                  ArtSweetAlert.show(
                                      context: context,
                                      artDialogArgs: ArtDialogArgs(
                                          dialogDecoration: BoxDecoration(
                                              color: Colors.white, borderRadius: BorderRadius.circular(20)),
                                          type: state.isEmpty ? ArtSweetAlertType.warning : ArtSweetAlertType.danger,
                                          title: state.isEmpty ? "Enter an email and password." : "Login Failed",
                                          text: state.isEmpty
                                              ? "Please make sure both fields are not empty."
                                              : "Incorrect email or password. Please try again."));
                                },
                              );
                            }),
                        const SizedBox(height: 10),
                        TextButton(
                          onPressed: () {
                            GoRouter.of(context).push("/forget_password");
                          },
                          child: const Text(
                            'Forgot your password?',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                  Positioned(
                    right: 20,
                    child: TextButton(
                      style: ButtonStyle(padding: MaterialStateProperty.all(const EdgeInsets.all(20))),
                      onPressed: () {
                        context.go("/onboarding");
                      },
                      child: const Text(
                        'SKIP',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
