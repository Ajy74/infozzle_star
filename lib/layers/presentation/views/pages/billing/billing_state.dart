import 'package:credit_card_form/credit_card_form.dart';

class BillingState {
  String country;
  String cardNumber;
  String cardHolderName;
  String expirationMonth;
  String expirationYear;
  String cvc;
  CardType cardType;

  BillingState({
    this.country = "",
    this.cardNumber = "",
    this.cardHolderName = "",
    this.expirationMonth = "",
    this.expirationYear = "",
    this.cvc = "",
    this.cardType = CardType.others,
  });

  BillingState.clone(BillingState existingState)
      : this(
          country: existingState.country,
          cardNumber: existingState.cardNumber,
          cardHolderName: existingState.cardHolderName,
          expirationMonth: existingState.expirationMonth,
          expirationYear: existingState.expirationYear,
          cvc: existingState.cvc,
          cardType: existingState.cardType,
        );
}
