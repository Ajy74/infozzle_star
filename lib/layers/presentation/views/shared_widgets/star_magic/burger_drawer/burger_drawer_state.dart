class BurgerDrawerState {
  bool isGuest;
  bool isActive;
  String version;

  BurgerDrawerState({
    this.isGuest = false,
    this.isActive = true,
    this.version = "",
  });

  BurgerDrawerState.clone(BurgerDrawerState existingState)
      : this(
          isGuest: existingState.isGuest,
          version: existingState.version,
          isActive: existingState.isActive,
        );
}
