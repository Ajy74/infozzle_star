class HomeState {
  int selectedIndex;
  bool isGuest;
  bool isActive;
  bool isLoading;

  HomeState({
    this.selectedIndex = 0,
    this.isGuest = false,
    this.isActive = true,
    this.isLoading = false,
  });

  HomeState.clone(HomeState existingState)
      : this(
            isGuest: existingState.isGuest,
            selectedIndex: existingState.selectedIndex,
            isLoading: existingState.isLoading,
            isActive: existingState.isActive);
}
