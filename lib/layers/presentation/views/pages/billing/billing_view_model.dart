import 'package:breathpacer/layers/presentation/views/pages/billing/billing_state.dart';
import 'package:credit_card_form/credit_card_form.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spinner_dropdown/spinner_list_item.dart';

import '../../../../../helpers/countries.dart';

class BillingViewModel extends Cubit<BillingState> {
  BillingViewModel() : super(BillingState()) {
    fetchCountries();
  }

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController address1Controller = TextEditingController();
  final TextEditingController address2Controller = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController countryStateController = TextEditingController();
  final TextEditingController postalCodeController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final countries = <SpinnerListItem>[];
  final List<FocusNode> focusNodes = List.generate(10, (index) => FocusNode());

  void fetchCountries() {
    List<String> countryStings = getCountries();
    for (String item in countryStings) {
      countries.add(SpinnerListItem(data: item));
    }
  }

  void updateCardInfo(String cardNumber, String cardHolderName, String expirationMonth, String expirationYear,
      String cvc, CardType type) {
    state.cardNumber = cardNumber;
    state.cardHolderName = cardHolderName;
    state.expirationMonth = expirationMonth;
    state.expirationYear = expirationYear;
    state.cvc = cvc;
    state.cardType = type;
    emit(BillingState.clone(state));
  }

  void setCountry(String country) {
    state.country = country;
    countryController.text = state.country;
    emit(BillingState.clone(state));
  }

  void reset() {
    emit(BillingState());
  }
}
