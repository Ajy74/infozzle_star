import '../../../../domain/models/event_model.dart';

class EventState {
  String countryCodeNumber;
  List<EventModel> events;
  List<String> categories;
  String selectedCategory;

  EventState({
    this.countryCodeNumber = "+1",
    this.selectedCategory = 'All',
    this.categories = const ["All", "Category 1", "Category 2", "Category 3"],
    this.events = const [],
  });

  EventState.clone(EventState existingState)
      : this(
            countryCodeNumber: existingState.countryCodeNumber,
            events: existingState.events,
            selectedCategory: existingState.selectedCategory,
            categories: existingState.categories);
}
