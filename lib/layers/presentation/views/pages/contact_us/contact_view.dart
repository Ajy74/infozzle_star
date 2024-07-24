import 'package:breathpacer/layers/presentation/views/shared_widgets/star_magic/authentication_text_field.dart';
import 'package:breathpacer/layers/presentation/views/shared_widgets/star_magic/custom_button.dart';
import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../theme/app_theme.dart';
import '../../shared_widgets/star_magic/burger_drawer/burger_drawer_view.dart';
import 'contact_state.dart';
import 'contact_view_model.dart';

class ContactUsView extends StatelessWidget {
  ContactUsView({super.key});

  final ContactUsViewModel viewModel = ContactUsViewModel();
  final countryPicker = const FlCountryCodePicker();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppTheme.colors.linearGradient),
      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          drawer: BurgerDrawerView(),
          appBar: AppBar(
            centerTitle: true,
            title: const Text("Contact Us"),
            titleTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
            iconTheme: const IconThemeData(color: Colors.white),
            backgroundColor: AppTheme.colors.appBarColor,
            actions: [
              IconButton(
                icon: const Icon(Icons.home_filled),
                onPressed: () {
                  context.go("/home");
                },
              ),
            ],
          ),
          body: BlocBuilder<ContactUsViewModel, ContactUsState>(
            bloc: viewModel,
            builder: (_, state) {
              return SafeArea(
                top: true,
                bottom: true,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [buildFormFields(state, context)],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget buildFormFields(ContactUsState state, BuildContext context) {
    return Column(
      children: <Widget>[
        const SizedBox(height: 10),
        AuthenticationTextField(
          hint: "First Name",
          obscure: false,
          controller: viewModel.firstNameController,
        ),
        AuthenticationTextField(
          hint: "Last Name",
          obscure: false,
          controller: viewModel.lastNameController,
        ),
        AuthenticationTextField(
          hint: "Email",
          obscure: false,
          controller: viewModel.emailController,
        ),
        AuthenticationTextField(
          hint: "Subject",
          obscure: false,
          controller: viewModel.subjectController,
        ),
        buildPhoneNumberField(context, state),
        AuthenticationTextField(
          hint: "Your Message",
          obscure: false,
          isDouble: true,
          controller: viewModel.messageController,
        ),
        const SizedBox(height: 10),
        CustomButton(buttonText: "Submit", color: AppTheme.colors.lightBlueButton, onTap: () {}),
        const SizedBox(height: 40),
      ],
    );
  }

  Widget buildPhoneNumberField(BuildContext context, ContactUsState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      child: Row(
        children: [
          GestureDetector(
            onTap: () async {
              final picked = await countryPicker.showPicker(context: context);
              if (picked != null) {
                viewModel.setCountryData(
                  picked.dialCode,
                  picked.code,
                  picked.name,
                  picked.flagImage(),
                );
              }
            },
            child: Container(
              height: 65,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              child: Row(
                children: [
                  state.countryImage,
                  const SizedBox(width: 5),
                  Text("(${state.countryCode})"),
                  const SizedBox(width: 5),
                  Text(
                    state.countryCodeNumber,
                    style: const TextStyle(color: Colors.black),
                  ),
                  const Icon(Icons.arrow_drop_down, color: Colors.grey),
                ],
              ),
            ),
          ),
          Expanded(
            child: AuthenticationTextField(
              hint: "Phone Number",
              obscure: false,
              controller: viewModel.numberController,
            ),
          ),
        ],
      ),
    );
  }
}
