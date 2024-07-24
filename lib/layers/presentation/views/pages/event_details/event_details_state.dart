class EventDetailsState {
  int count;

  EventDetailsState({
    this.count = 0,
  });

  EventDetailsState.clone(EventDetailsState existingState) : this(count: existingState.count);
}
