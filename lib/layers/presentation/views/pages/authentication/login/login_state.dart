class LoginState {
  bool isEmpty;

  LoginState({
    this.isEmpty = false,
  });

  LoginState.clone(LoginState existingState) : this(isEmpty: existingState.isEmpty);
}
