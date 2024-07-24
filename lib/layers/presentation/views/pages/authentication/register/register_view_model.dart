import 'package:breathpacer/helpers/countries.dart';
import 'package:breathpacer/layers/presentation/views/pages/authentication/register/register_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spinner_dropdown/spinner_list_item.dart';

class RegisterViewModel extends Cubit<RegisterState> {
  RegisterViewModel() : super(RegisterState()) {
    fetchCountries();
  }

  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController address1Controller = TextEditingController();
  final TextEditingController address2Controller = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController countryStateController = TextEditingController();
  final TextEditingController postalCodeController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  final countries = <SpinnerListItem>[];

  void fetchCountries() {
    List<String> countryStings = getCountries();
    for (String item in countryStings) {
      countries.add(SpinnerListItem(data: item));
    }
  }

  void toggleIsAccepted() {
    state.isAccepted = !state.isAccepted;
    emit(RegisterState.clone(state));
  }

  void setCountry(String country) {
    state.country = country;
    countryController.text = state.country;
    emit(RegisterState.clone(state));
  }

  void reset() {
    emit(RegisterState());
  }
}
