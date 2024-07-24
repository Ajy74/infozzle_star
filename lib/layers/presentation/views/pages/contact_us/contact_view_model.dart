import 'package:breathpacer/layers/presentation/views/pages/contact_us/contact_state.dart';
import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContactUsViewModel extends Cubit<ContactUsState> {
  ContactUsViewModel() : super(ContactUsState());

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController subjectController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController messageController = TextEditingController();

  void setCountryData(
      String countryCodeNumber, String countryCode, String countryName, CountryCodeFlagWidget countryImage) {
    state.countryCodeNumber = countryCodeNumber;
    state.countryImage = countryImage;
    state.countryName = countryName;
    state.countryCode = countryCode;
    emit(ContactUsState.clone(state));
  }

  void reset() {
    emit(ContactUsState());
  }
}
