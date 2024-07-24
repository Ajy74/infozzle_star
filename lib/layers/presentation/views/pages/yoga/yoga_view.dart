import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:breathpacer/layers/presentation/views/pages/yoga/yoga_state.dart';
import 'package:breathpacer/layers/presentation/views/pages/yoga/yoga_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../theme/app_theme.dart';
import '../../shared_widgets/star_magic/burger_drawer/burger_drawer_view.dart';
import '../../shared_widgets/star_magic/custom_video_player.dart';
import '../../shared_widgets/star_magic/search_bar.dart';

class YogaView extends StatelessWidget {
  YogaView({super.key});

  final YogaViewModel viewModel = YogaViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: const Text("Yoga"),
        centerTitle: true,
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
      drawer: BurgerDrawerView(),
      body: BlocBuilder<YogaViewModel, YogaState>(
        bloc: viewModel,
        builder: (_, state) {
          if (state.showErrorMessage) {
            Future.microtask(() => ArtSweetAlert.show(
                  context: context,
                  artDialogArgs: ArtDialogArgs(
                    dialogDecoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    type: ArtSweetAlertType.danger,
                    title: "Failed to fetch Videos",
                    text: "An error occurred while fetching videos, please try again.",
                  ),
                ));
            state.showErrorMessage = false;
          }
          return Column(
            children: [
              CustomSearchBar(
                controller: viewModel.controller,
                color: AppTheme.colors.appBarColor,
                isCenter: false,
                hintText: 'Search Yoga Videos',
                onChanged: (String value) {
                  viewModel.updateSearchText(value);
                },
                isTappable: true,
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const ScrollPhysics(),
                  child: Column(
                    children: [
                      if (state.isLoading)
                        const Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      CustomVideos(
                        videos: state.videoList,
                        textColor: Colors.black,
                        startFullScreen: true,
                        isYoutube: false,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
