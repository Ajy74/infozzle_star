import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/cupertino.dart';

class ContactUsState {
  String countryCodeNumber;
  String countryName;
  String countryCode;
  CountryCodeFlagWidget countryImage;

  ContactUsState({
    this.countryCodeNumber = "+1",
    this.countryCode = "US",
    this.countryName = "United States",
    this.countryImage = const CountryCodeFlagWidget(
        width: 32,
        alignment: Alignment.center,
        countryCode: CountryCode(name: "United States", code: "US", dialCode: "+1")),
  });

  ContactUsState.clone(ContactUsState existingState)
      : this(
            countryCodeNumber: existingState.countryCodeNumber,
            countryName: existingState.countryName,
            countryCode: existingState.countryCode,
            countryImage: existingState.countryImage);
}
