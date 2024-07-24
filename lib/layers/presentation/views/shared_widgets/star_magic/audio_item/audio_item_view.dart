import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:breathpacer/layers/presentation/views/shared_widgets/star_magic/audio_item/widgets/vault_popup_selector_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../theme/app_theme.dart';
import '../../../../../domain/models/audio_section_model.dart';
import '../../../../../domain/models/light_language_audio.dart';
import '../../../pages/audio_player/audio_player_view_model.dart';
import '../zoomable_image.dart';
import 'audio_item_state.dart';
import 'audio_item_view_model.dart';
import 'widgets/playlist_popup_selector_item.dart';

class AudioItemView extends StatelessWidget {
  AudioItemView({super.key, required this.model}) {
    viewModel.setModel(model);
    viewModel.updateCurrentAudioState();
  }

  final AudioSectionModel model;
  final AudioItemViewModel viewModel = AudioItemViewModel();

  @override
  Widget build(BuildContext context) {
    final audioViewModel = context.read<AudioPlayerViewModel>();

    return Container(
      decoration: BoxDecoration(gradient: AppTheme.colors.linearGradient),
      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(model.title),
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
          body: BlocBuilder<AudioItemViewModel, AudioItemState>(
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
                        title: "Failed to Get Audio Info",
                        text: "An error occurred while getting audio data, please try again.",
                      ),
                    ));
                state.showErrorMessage = false;
              }
              return SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    buildImage(context, audioViewModel),
                    const SizedBox(height: 10),
                    if (!viewModel.state.isLoading) buildActionButtons(audioViewModel, model),
                    const SizedBox(height: 10),
                    if (!viewModel.state.isLoading)
                      Text(
                        state.audio.title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    const SizedBox(height: 10),
                    if (!viewModel.state.isLoading)
                      Text(
                        state.audio.description,
                        style: const TextStyle(fontSize: 12, color: Colors.white),
                        textAlign: TextAlign.center,
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget buildImage(BuildContext context, AudioPlayerViewModel audioViewModel) {
    if (!viewModel.state.isLoading) {
      return ZoomableImageDialog(
          imageUrl: viewModel.state.audio.image, audioViewModel: audioViewModel, viewModel: viewModel);
    }
    return const Padding(
        padding: EdgeInsets.only(top: 20),
        child: Center(
          child: CircularProgressIndicator(color: Colors.white),
        ));
  }

  Widget buildActionButtons(AudioPlayerViewModel audioViewModel, AudioSectionModel audio) {
    return SizedBox(
      width: 380,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            style: TextButton.styleFrom(backgroundColor: Colors.transparent, padding: EdgeInsets.zero),
            onPressed: () {
              viewModel.toggleLiked(audio);
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.thumb_up,
                  size: 20,
                  color: viewModel.state.isLiked ? AppTheme.colors.pinkButton : Colors.white,
                ),
                const SizedBox(width: 5),
                const Text(
                  "Like",
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ],
            ),
          ),
          if (viewModel.state.isLoadingUserPlaylists)
            const Padding(
              padding: EdgeInsets.only(top: 0),
              child: SizedBox(
                width: 20,
                height: 20,
                child: Center(
                  child: CircularProgressIndicator(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          if (!viewModel.state.isLoadingUserPlaylists)
            PlaylistsPopupSelectorItem(
              title: 'Select Your Playlist',
              viewModel: viewModel,
              model: viewModel.state.playlistsNames,
              onTap: (selectedTitle) {},
              icon: Icon(
                Icons.favorite,
                color: viewModel.state.isAddedToPlaylist ? AppTheme.colors.pinkButton : Colors.white,
              ),
            ),
          VaultsPopupSelectorItem(
              title: 'Select Your Vault',
              filename: viewModel.state.audio.id.toString(),
              url: viewModel.state.audio.audioURL,
              viewModel: viewModel,
              model: viewModel.state.vaultNames,
              onTap: (selectedTitle) {},
              audio: mapAudioToLightLanguageAudio(model)),
        ],
      ),
    );
  }

  LightLanguageAudioModel mapAudioToLightLanguageAudio(AudioSectionModel model) {
    return LightLanguageAudioModel(
        id: model.id,
        title: model.title,
        image: model.image,
        audioURL: model.audioURL,
        originalURL: model.originalURL,
        isDownloaded: model.isDownloaded,
        downloadedAt: "",
        isAddedToPlaylist: false,
        savedInPlaylists: [],
        savedInVaults: []);
  }
}
