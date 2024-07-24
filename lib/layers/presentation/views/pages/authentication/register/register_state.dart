class RegisterState {
  bool isAccepted;
  String country;

  RegisterState({this.isAccepted = false, this.country = "Country"});

  RegisterState.clone(RegisterState existingState) : this(isAccepted: existingState.isAccepted);
}
