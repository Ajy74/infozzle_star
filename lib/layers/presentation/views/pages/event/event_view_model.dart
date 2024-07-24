import 'package:breathpacer/layers/presentation/views/pages/event/event_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain/models/event_model.dart';

class EventViewModel extends Cubit<EventState> {
  EventViewModel() : super(EventState()) {
    populateEvents();
  }

  void populateEvents() {
    var allEvents = [
      EventModel(
          title: "Infinite Wisdom 19- Grand Central Sun, Council Of Light Exploration, Online",
          date: "May 25 - May 26",
          image: "https://placehold.co/1920x1080.jpg",
          canBook: true,
          isDiscounted: false,
          category: "Category 1",
          price: 5.0,
          discountedPrice: 0,
          text:
              " Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla cursus, dolor id accumsan laoreet, justo odio viverra est, sit amet egestas elit neque in purus. Phasellus ullamcorper bibendum purus, vitae dignissim nunc commodo vel. Sed sollicitudin justo commodo enim feugiat, at dictum nibh sollicitudin. Vivamus dignissim, lorem ac aliquet euismod, felis eros congue nisi, sed pulvinar augue mi in diam. Curabitur luctus vestibulum purus, et ornare eros commodo vel. Vivamus sit amet tristique felis. Ut nec nisi ut turpis tempor tincidunt. Proin in velit purus. Maecenas mattis elit nec quam fringilla accumsan. Pellentesque in mi ullamcorper risus elementum semper. Mauris turpis ipsum, elementum at suscipit quis, aliquet non purus."),
      EventModel(
          title: "Infinity Group Call, May 2024",
          date: "May 20 @5:00 pm - 5:30 pm",
          image: "https://placehold.co/1920x1080.jpg",
          canBook: false,
          isDiscounted: false,
          category: "Call",
          price: 8.0,
          discountedPrice: 0,
          text:
              " Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla cursus, dolor id accumsan laoreet, justo odio viverra est, sit amet egestas elit neque in purus. Phasellus ullamcorper bibendum purus, vitae dignissim nunc commodo vel. Sed sollicitudin justo commodo enim feugiat, at dictum nibh sollicitudin. Vivamus dignissim, lorem ac aliquet euismod, felis eros congue nisi, sed pulvinar augue mi in diam. Curabitur luctus vestibulum purus, et ornare eros commodo vel. Vivamus sit amet tristique felis. Ut nec nisi ut turpis tempor tincidunt. Proin in velit purus. Maecenas mattis elit nec quam fringilla accumsan. Pellentesque in mi ullamcorper risus elementum semper. Mauris turpis ipsum, elementum at suscipit quis, aliquet non purus."),
      EventModel(
          title: "Infinite Wisdom 20",
          date: "June 2 - June 6",
          image: "https://placehold.co/1920x1080.jpg",
          canBook: true,
          isDiscounted: false,
          category: "Category 2",
          discountedPrice: 0,
          price: 10.0,
          text:
              " Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla cursus, dolor id accumsan laoreet, justo odio viverra est, sit amet egestas elit neque in purus. Phasellus ullamcorper bibendum purus, vitae dignissim nunc commodo vel. Sed sollicitudin justo commodo enim feugiat, at dictum nibh sollicitudin. Vivamus dignissim, lorem ac aliquet euismod, felis eros congue nisi, sed pulvinar augue mi in diam. Curabitur luctus vestibulum purus, et ornare eros commodo vel. Vivamus sit amet tristique felis. Ut nec nisi ut turpis tempor tincidunt. Proin in velit purus. Maecenas mattis elit nec quam fringilla accumsan. Pellentesque in mi ullamcorper risus elementum semper. Mauris turpis ipsum, elementum at suscipit quis, aliquet non purus."),
      EventModel(
          title: "Day of the Dead",
          date: "July 27 @5:00 pm - 5:30 pm",
          image: "https://placehold.co/1920x1080.jpg",
          canBook: false,
          isDiscounted: false,
          category: "Category 3",
          price: 20.0,
          discountedPrice: 0,
          text:
              " Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla cursus, dolor id accumsan laoreet, justo odio viverra est, sit amet egestas elit neque in purus. Phasellus ullamcorper bibendum purus, vitae dignissim nunc commodo vel. Sed sollicitudin justo commodo enim feugiat, at dictum nibh sollicitudin. Vivamus dignissim, lorem ac aliquet euismod, felis eros congue nisi, sed pulvinar augue mi in diam. Curabitur luctus vestibulum purus, et ornare eros commodo vel. Vivamus sit amet tristique felis. Ut nec nisi ut turpis tempor tincidunt. Proin in velit purus. Maecenas mattis elit nec quam fringilla accumsan. Pellentesque in mi ullamcorper risus elementum semper. Mauris turpis ipsum, elementum at suscipit quis, aliquet non purus."),
    ];

    state.events = allEvents;
    emit(EventState.clone(state));
  }

  void updateCategory(String newCategory) {
    state.selectedCategory = newCategory;
    emit(EventState.clone(state));
  }

  void reset() {
    emit(EventState());
  }

  Map<String, List<EventModel>> groupEventsByMonth(List<EventModel> events) {
    final Map<String, List<EventModel>> groupedEvents = {};

    for (var event in events) {
      final monthYear = getMonthYear(event.date);
      if (!groupedEvents.containsKey(monthYear)) {
        groupedEvents[monthYear] = [];
      }
      groupedEvents[monthYear]!.add(event);
    }

    return groupedEvents;
  }

  String getMonthYear(String date) {
    final month = extractFirstMonth(date);
    final currentYear = DateTime.now().year.toString();
    return "$month $currentYear";
  }

  String extractFirstMonth(String date) {
    final months = [
      "January",
      "February",
      "March",
      "April",
      "May",
      "June",
      "July",
      "August",
      "September",
      "October",
      "November",
      "December"
    ];

    for (var month in months) {
      if (date.contains(month)) {
        return month;
      }
    }
    return "";
  }
}
