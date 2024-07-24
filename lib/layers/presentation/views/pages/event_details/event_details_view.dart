import 'package:cached_network_image/cached_network_image.dart';
import 'package:cart_stepper/cart_stepper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../../theme/app_theme.dart';
import '../../../../domain/models/event_model.dart';
import 'event_details_state.dart';
import 'event_details_view_model.dart';

//ignore: must_be_immutable
class EventDetailView extends StatelessWidget {
  EventDetailView({super.key, required this.model});

  final EventModel model;
  EventDetailsViewModel viewModel = EventDetailsViewModel();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
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
                child: BlocBuilder<EventDetailsViewModel, EventDetailsState>(
                  bloc: viewModel,
                  builder: (_, state) {
                    return SafeArea(
                      top: true,
                      bottom: true,
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            if (model.canBook) buildAddToCartArea(context, state.count),
                            const SizedBox(height: 10),
                            buildImage(),
                            const SizedBox(height: 15),
                            Text(model.text),
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

  Widget buildAddToCartArea(BuildContext context, int count) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 1,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              model.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Row(children: [
              Text(
                model.date,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const Spacer(),
              Text(
                "\$${model.price.toString()}",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.colors.primaryColor,
                ),
              ),
            ]),
            const SizedBox(height: 16),
            Row(
              children: [
                CartStepperInt(
                  value: count,
                  size: 40,
                  alwaysExpanded: true,
                  style: CartStepperTheme.of(context).copyWith(
                      activeForegroundColor: Colors.white, activeBackgroundColor: AppTheme.colors.primaryColor),
                  didChangeCount: (newCount) {
                    viewModel.updateCount(newCount);
                  },
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    //TODO: Add item to user cart on database
                    GoRouter.of(context).push("/cart");
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    backgroundColor: Colors.redAccent,
                  ),
                  child: const Text(
                    'Add to Cart',
                    style: TextStyle(fontSize: 16, color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildImage() {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(0.0),
        child: CachedNetworkImage(
          imageUrl: model.image,
          progressIndicatorBuilder: (context, url, downloadProgress) => Shimmer(
              gradient: AppTheme.colors.linearLoading,
              child: Container(color: Colors.white, width: 1920, height: 1080)),
          errorWidget: (context, url, error) => const Icon(Icons.error),
          width: 1920,
          height: 1080,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
