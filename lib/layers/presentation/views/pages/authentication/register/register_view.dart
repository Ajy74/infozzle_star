import 'package:breathpacer/helpers/enums/breathing_enum.dart';
import 'package:breathpacer/layers/presentation/views/pages/authentication/register/register_state.dart';
import 'package:breathpacer/layers/presentation/views/pages/authentication/register/register_view_model.dart';
import 'package:breathpacer/layers/presentation/views/shared_widgets/star_magic/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spinner_dropdown/spinner.dart';
import 'package:spinner_dropdown/spinner_list_item.dart';

import '../../../../../../theme/app_theme.dart';
import '../../../shared_widgets/breathpacer/components/top_area_breathing.dart';
import '../../../shared_widgets/star_magic/authentication_text_field.dart';

class RegisterView extends StatelessWidget {
  RegisterView({super.key});

  final RegisterViewModel viewModel = RegisterViewModel();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppTheme.colors.linearGradient),
      child: SafeArea(
        top: true,
        bottom: true,
        child: Scaffold(
          body: BlocBuilder<RegisterViewModel, RegisterState>(
            bloc: viewModel,
            builder: (_, state) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      child: TopArea(
                        onBackButtonPressed: () {},
                        title: 'SIGN UP NOW',
                        hasIcon: false,
                        iconTitle: '',
                        iconEnum: BreathingIconEnum.nothing,
                        hasBackButton: false,
                      ),
                    ),
                    buildFormFields(state, context)
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget buildFormFields(RegisterState state, BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
            alignment: AlignmentDirectional.centerStart,
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            child: const Text("Account Information",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18))),
        AuthenticationTextField(hint: "User Name", obscure: false, controller: viewModel.usernameController),
        AuthenticationTextField(hint: "Email", obscure: false, controller: viewModel.emailController, isEmail: true),
        AuthenticationTextField(hint: "Password", obscure: true, controller: viewModel.passwordController),
        AuthenticationTextField(
            hint: "Confirm Password", obscure: true, controller: viewModel.confirmPasswordController),
        const SizedBox(height: 20),
        Container(
            alignment: AlignmentDirectional.centerStart,
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            child: const Text("Billing Information",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18))),
        AuthenticationTextField(hint: "First Name", obscure: false, controller: viewModel.firstNameController),
        AuthenticationTextField(hint: "Last Name", obscure: false, controller: viewModel.lastNameController),
        AuthenticationTextField(
            hint: "Address 1", obscure: false, isDouble: true, controller: viewModel.address1Controller),
        AuthenticationTextField(
            hint: "Address 2", obscure: false, isDouble: true, controller: viewModel.address2Controller),
        AuthenticationTextField(hint: "City", obscure: false, controller: viewModel.cityController),
        AuthenticationTextField(hint: "State", obscure: false, controller: viewModel.countryStateController),
        AuthenticationTextField(hint: "Postal Code", obscure: false, controller: viewModel.postalCodeController),
        AuthenticationTextField(hint: "Phone", obscure: false, controller: viewModel.phoneController),
        AuthenticationTextField(
            hint: state.country,
            obscure: false,
            isCountry: true,
            onTap: () {
              onTextFieldTap(context);
            },
            controller: viewModel.countryController),
        const SizedBox(height: 10),
        CheckboxListTile(
          title: const Text(
            "Accept Terms and Conditions",
            style: TextStyle(color: Colors.white),
          ),
          value: state.isAccepted,
          onChanged: (bool? value) {
            viewModel.toggleIsAccepted();
          },
          controlAffinity: ListTileControlAffinity.leading,
          activeColor: AppTheme.colors.lightBlueButton,
          checkColor: Colors.white,
        ),
        CustomButton(buttonText: "Sign up", color: AppTheme.colors.lightBlueButton, onTap: () {}),
        const SizedBox(height: 10),
        Center(
          child: TextButton(
            onPressed: () {
              GoRouter.of(context).push("/login");
            },
            child: const Text(
              "ALREADY HAVE AN ACCOUNT? SIGN IN",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }

  void onTextFieldTap(BuildContext context) {
    SpinnerState(
      Spinner(
        bottomSheetTitle: const Text(
          'Countries',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20.0,
          ),
        ),
        data: viewModel.countries,
        selectedItems: (List<dynamic> selectedList) {
          List<String> list = [];
          for (var item in selectedList) {
            if (item is SpinnerListItem) {
              list.add(item.data.toString());
              viewModel.setCountry(item.data.toString());
            }
          }
        },
        enableMultipleSelection: false,
      ),
    ).showModal(context);
  }
}
