import 'package:flutter_bloc/flutter_bloc.dart';

import 'event_details_state.dart';

class EventDetailsViewModel extends Cubit<EventDetailsState> {
  EventDetailsViewModel() : super(EventDetailsState());

  void updateCount(int newCount) {
    state.count = newCount;
    emit(EventDetailsState.clone(state));
  }

  void reset() {
    emit(EventDetailsState());
  }
}
