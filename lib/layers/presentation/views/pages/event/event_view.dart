import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../../theme/app_theme.dart';
import '../../../../domain/models/event_model.dart';
import '../../shared_widgets/star_magic/burger_drawer/burger_drawer_view.dart';
import '../../shared_widgets/star_magic/custom_button.dart';
import 'event_state.dart';
import 'event_view_model.dart';

class EventsView extends StatelessWidget {
  EventsView({super.key});

  final EventViewModel viewModel = EventViewModel();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          drawer: BurgerDrawerView(),
          appBar: AppBar(
            centerTitle: true,
            title: const Text("Attend an Event"),
            titleTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
            iconTheme: const IconThemeData(color: Colors.white),
            backgroundColor: AppTheme.colors.appBarColor,
            actions: [
              IconButton(
                icon: const Icon(Icons.home_filled),
                onPressed: () {
                  context.go("/home");
                },
              ),
            ],
          ),
          body: Column(
            children: [
              Expanded(
                child: BlocBuilder<EventViewModel, EventState>(
                  bloc: viewModel,
                  builder: (_, state) {
                    return SafeArea(
                      top: true,
                      bottom: true,
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            buildDropDown(state, context),
                            buildEvents(state.events, state.selectedCategory, context)
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDropDown(EventState state, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: DropdownButtonHideUnderline(
        child: DropdownButton2<String>(
          isExpanded: true,
          hint: Text(
            'Select a category',
            style: TextStyle(
              fontSize: 16,
              color: Theme.of(context).hintColor,
            ),
          ),
          value: state.selectedCategory,
          onChanged: (String? newValue) {
            viewModel.updateCategory(newValue ?? "All");
          },
          items: state.categories.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                ),
              ),
            );
          }).toList(),
          buttonStyleData: ButtonStyleData(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: AppTheme.colors.primaryColor,
                width: 1,
              ),
            ),
            width: double.infinity,
          ),
          dropdownStyleData: DropdownStyleData(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildEvents(List<EventModel> events, String selectedCategory, BuildContext context) {
    final filteredEvents =
        selectedCategory == 'All' ? events : events.where((event) => event.category == selectedCategory).toList();
    final groupedEvents = viewModel.groupEventsByMonth(filteredEvents);

    return Column(
      children: groupedEvents.entries.map((entry) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 10),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(width: 80, height: 10, decoration: BoxDecoration(gradient: AppTheme.colors.linearEvent)),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  entry.key,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppTheme.colors.primaryColor),
                ),
              ),
              Container(width: 80, height: 10, decoration: BoxDecoration(gradient: AppTheme.colors.linearEvent)),
            ]),
            Column(
              children: entry.value.map((event) => buildEventCard(event, context)).toList(),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget buildEventCard(EventModel event, BuildContext context) {
    return GestureDetector(
      onTap: () {
        GoRouter.of(context).push("/event_details", extra: event);
      },
      child: Card(
        margin: const EdgeInsets.all(20),
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        elevation: 8.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 16 / 9,
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(0.0),
                  topRight: Radius.circular(0.0),
                ),
                child: CachedNetworkImage(
                  imageUrl: event.image,
                  progressIndicatorBuilder: (context, url, downloadProgress) => Shimmer(
                      gradient: AppTheme.colors.linearLoading,
                      child: Container(color: Colors.white, width: 1920, height: 1080)),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  width: 1920,
                  height: 1080,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                event.title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.colors.eventPrimary,
                ),
              ),
            ),
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Text(
                event.date,
                style: TextStyle(fontSize: 15, color: AppTheme.colors.primaryColor),
              ),
            ),
            const SizedBox(height: 5),
            if (event.canBook)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: CustomButton(
                    buttonText: "Book Now",
                    color: AppTheme.colors.lightBlueButton,
                    onTap: () {
                      //TODO: Add item to user cart on database
                      GoRouter.of(context).push("/cart");
                    }),
              ),
            const SizedBox(height: 5),
          ],
        ),
      ),
    );
  }
}
