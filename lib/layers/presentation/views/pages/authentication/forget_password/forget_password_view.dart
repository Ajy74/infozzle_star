import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:breathpacer/layers/presentation/views/pages/authentication/forget_password/forget_password_state.dart';
import 'package:breathpacer/layers/presentation/views/pages/authentication/forget_password/forget_password_view_model.dart';
import 'package:breathpacer/layers/presentation/views/shared_widgets/star_magic/authentication_text_field.dart';
import 'package:breathpacer/layers/presentation/views/shared_widgets/star_magic/custom_button.dart';
import 'package:breathpacer/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../helpers/images.dart';

class ForgotPasswordView extends StatelessWidget {
  ForgotPasswordView({super.key});

  final ForgetPasswordViewModel viewModel = ForgetPasswordViewModel();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      decoration: BoxDecoration(
        gradient: AppTheme.colors.linearGradient,
      ),
      child: SafeArea(
        top: true,
        bottom: true,
        child: Scaffold(
          body: SingleChildScrollView(
            // Make the entire body scrollable
            child: BlocBuilder<ForgetPasswordViewModel, ForgetPasswordState>(
              bloc: viewModel,
              builder: (_, state) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(height: 70),
                      Image.asset(Images.passwordIcon, width: 90, height: 120, color: Colors.white),
                      const SizedBox(height: 40),
                      const Text(
                        'FORGOT PASSWORD',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 22.5,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Please Enter your Registered Email Address',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 30),
                      AuthenticationTextField(
                          obscure: false, hint: "Email", controller: viewModel.emailController, isEmail: true),
                      const SizedBox(height: 25),
                      CustomButton(
                          buttonText: "Send",
                          color: AppTheme.colors.lightBlueButton,
                          onTap: () {
                            if (viewModel.emailController.text == "") {
                              ArtSweetAlert.show(
                                  context: context,
                                  artDialogArgs: ArtDialogArgs(
                                      dialogDecoration:
                                          BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                                      type: ArtSweetAlertType.warning,
                                      title: "Enter an email address",
                                      text: "Please make sure the email field is not empty."));
                            }
                          }),
                      TextButton(
                        onPressed: () {
                          GoRouter.of(context).push("/login");
                        },
                        child: const Text(
                          'BACK TO LOGIN PAGE',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                      const SizedBox(height: 45),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
