import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../../theme/app_theme.dart';
import '../../shared_widgets/star_magic/burger_drawer/burger_drawer_view.dart';
import '../../shared_widgets/star_magic/search_bar.dart';
import '../audio_player/audio_player_view_model.dart';
import 'light_language_state.dart';
import 'light_language_view_model.dart';

class LightLanguageView extends StatelessWidget {
  LightLanguageView({super.key});

  final LightLanguageViewModel viewModel = LightLanguageViewModel();

  @override
  Widget build(BuildContext context) {
    final double size =  MediaQuery.of(context).size.width ;
    
    final audioViewModel = context.read<AudioPlayerViewModel>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: const Text("Light Language"),
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
      body: BlocBuilder<LightLanguageViewModel, LightLanguageState>(
        bloc: viewModel,
        builder: (_, state) {
          if (state.showErrorMessage) {
            Future.microtask(() => ArtSweetAlert.show(
                  context: context,
                  artDialogArgs: ArtDialogArgs(
                    dialogDecoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(0),
                    ),
                    type: ArtSweetAlertType.danger,
                    title: "Failed to fetch Audio",
                    text: "An error occurred while fetching audio, please try again.",
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
                hintText: 'Search Light Language',
                onChanged: (_) {
                  viewModel.updateSearchText();
                },
                isTappable: true,
              ),
              if (state.isLoading)
                const Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              Expanded(child: buildAudio(context, state, audioViewModel, size)),
            ],
          );
        },
      ),
    );
  }

  Widget buildAudio(BuildContext context, LightLanguageState state, AudioPlayerViewModel audioViewModel, double size) {
    return SizedBox(
      width: size,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: state.audioList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(top:size*0.045),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    viewModel.moveToBeginning(state.audioList, index);
                    audioViewModel.populateAudioList(state.audioList);
                    audioViewModel.updateCurrentAudioState();
                    audioViewModel.setAudioPlayer(
                        audioViewModel.state.allAudioList[audioViewModel.state.currentAudioIndex].audioURL, false);
                    GoRouter.of(context).push("/audio_player");
                  },
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: size*0.06),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(0.0),
                      child: CachedNetworkImage(
                        imageUrl: state.audioList[index].image,
                        progressIndicatorBuilder: (context, url, downloadProgress) => Shimmer(
                            gradient: AppTheme.colors.linearLoading,
                            child: Container(color: Colors.white, width: size, height: size*0.7)),
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                        width: size*0.8,
                        height: size*0.8,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: size*0.03),
                Text(
                  state.audioList[index].title,
                  style: TextStyle(
                    fontSize: size*0.048,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
