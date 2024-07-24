import 'package:breathpacer/layers/presentation/views/pages/billing/billing_state.dart';
import 'package:breathpacer/layers/presentation/views/pages/billing/billing_view_model.dart';
import 'package:breathpacer/layers/presentation/views/shared_widgets/star_magic/custom_button.dart';
import 'package:credit_card_form/credit_card_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:spinner_dropdown/spinner.dart';
import 'package:spinner_dropdown/spinner_list_item.dart';

import '../../../../../../theme/app_theme.dart';
import '../../shared_widgets/star_magic/authentication_text_field.dart';
import '../../shared_widgets/star_magic/burger_drawer/burger_drawer_view.dart';

class BillingView extends StatelessWidget {
  BillingView({super.key});

  final BillingViewModel viewModel = BillingViewModel();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppTheme.colors.linearGradient),
      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          appBar: AppBar(
            iconTheme: const IconThemeData(color: Colors.white),
            centerTitle: true,
            backgroundColor: Colors.transparent,
            actions: [
              IconButton(
                icon: const Icon(Icons.home_filled),
                onPressed: () {
                  context.go("/home");
                },
              ),
            ],
          ),
          drawer: BurgerDrawerView(),
          body: BlocBuilder<BillingViewModel, BillingState>(
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

  Widget buildFormFields(BillingState state, BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
            alignment: AlignmentDirectional.centerStart,
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            child: const Text("Billing Information",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18))),
        AuthenticationTextField(
            hint: "First Name",
            obscure: false,
            controller: viewModel.firstNameController,
            focusNode: viewModel.focusNodes[0],
            nextFocusNode: viewModel.focusNodes[1]),
        AuthenticationTextField(
            hint: "Last Name",
            obscure: false,
            controller: viewModel.lastNameController,
            focusNode: viewModel.focusNodes[1],
            nextFocusNode: viewModel.focusNodes[2]),
        AuthenticationTextField(
            hint: "Email",
            isEmail: true,
            obscure: false,
            controller: viewModel.emailController,
            focusNode: viewModel.focusNodes[2],
            nextFocusNode: viewModel.focusNodes[3]),
        AuthenticationTextField(
            hint: "Address 1",
            obscure: false,
            isDouble: true,
            controller: viewModel.address1Controller,
            focusNode: viewModel.focusNodes[3],
            nextFocusNode: viewModel.focusNodes[4]),
        AuthenticationTextField(
            hint: "Address 2",
            obscure: false,
            isDouble: true,
            controller: viewModel.address2Controller,
            focusNode: viewModel.focusNodes[4],
            nextFocusNode: viewModel.focusNodes[5]),
        AuthenticationTextField(
            hint: "City",
            obscure: false,
            controller: viewModel.cityController,
            focusNode: viewModel.focusNodes[5],
            nextFocusNode: viewModel.focusNodes[6]),
        AuthenticationTextField(
            hint: "State",
            obscure: false,
            controller: viewModel.countryStateController,
            focusNode: viewModel.focusNodes[6],
            nextFocusNode: viewModel.focusNodes[7]),
        AuthenticationTextField(
            hint: "Postal Code",
            obscure: false,
            controller: viewModel.postalCodeController,
            focusNode: viewModel.focusNodes[7],
            nextFocusNode: viewModel.focusNodes[8]),
        AuthenticationTextField(
            hint: "Phone",
            obscure: false,
            controller: viewModel.phoneController,
            focusNode: viewModel.focusNodes[8],
            nextFocusNode: viewModel.focusNodes[9]),
        AuthenticationTextField(
            hint: "Country",
            obscure: false,
            isCountry: true,
            onTap: () {
              onTextFieldTap(context);
            },
            controller: viewModel.countryController,
            focusNode: viewModel.focusNodes[9]),
        Container(
            alignment: AlignmentDirectional.centerStart,
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            child: const Text("Payment Information",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18))),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
          child: CreditCardForm(
            theme: CreditCardLightTheme(),
            onChanged: (CreditCardResult result) {
              viewModel.updateCardInfo(result.cardNumber, result.cardHolderName, result.expirationMonth,
                  result.expirationYear, result.cvc, result.cardType ?? CardType.visa);
            },
          ),
        ),
        const SizedBox(height: 10),
        CustomButton(
            buttonText: "Place order",
            color: AppTheme.colors.lightBlueButton,
            onTap: () {
              GoRouter.of(context).push("/purchase_complete");
            }),
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
