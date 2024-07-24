import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:breathpacer/layers/domain/models/playlist_model.dart';
import 'package:breathpacer/layers/presentation/views/pages/my_playlists/my_playlists_state.dart';
import 'package:breathpacer/layers/presentation/views/pages/my_playlists/widgets/my_playlists_grid_view.dart';
import 'package:breathpacer/theme/app_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../domain/models/audio_section_model.dart';
import '../../../../domain/models/light_language_audio.dart';
import '../../shared_widgets/star_magic/burger_drawer/burger_drawer_view.dart';
import '../../shared_widgets/star_magic/dialog.dart';
import '../audio_player/audio_player_view_model.dart';
import 'my_playlists_view_model.dart';

class MyPlaylistsView extends StatelessWidget {
  MyPlaylistsView({super.key});

  final MyPlaylistsViewModel viewModel = MyPlaylistsViewModel();

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
            title: const Text("My Playlists    "),
            centerTitle: true,
            titleTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
            iconTheme: const IconThemeData(color: Colors.white),
            backgroundColor: AppTheme.colors.appBarColor,
            actions: [
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  padding: EdgeInsets.zero,
                  maximumSize: const Size(100, 45),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const SizedBox(
                  height: 45,
                  child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
                    Icon(Icons.add_circle_rounded, color: Colors.white, size: 20),
                    Text("Add Playlist", style: TextStyle(fontSize: 12, color: Colors.white))
                  ]),
                ),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => CustomDialog(
                      title: 'Add New Playlist',
                      hint: "Playlist Name",
                      onTap: (newName) {
                        viewModel.addPlaylist(newName);
                      },
                    ),
                  );
                },
              ),
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  padding: EdgeInsets.zero,
                  maximumSize: const Size(100, 45),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const SizedBox(height: 45, child: Icon(Icons.home_filled, color: Colors.white, size: 30)),
                onPressed: () {
                  context.go("/home");
                },
              ),
            ],
          ),
          drawer: BurgerDrawerView(),
          body: BlocBuilder<MyPlaylistsViewModel, MyPlaylistsState>(
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
                        title: state.errorTitle,
                        text: state.errorMessage,
                      ),
                    ));
                state.showErrorMessage = false;
              }
              return SafeArea(
                top: true,
                bottom: true,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      if (state.isLoading)
                        const Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: Center(
                            child: CircularProgressIndicator(color: Colors.white),
                          ),
                        ),
                      ListView.builder(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.playlists.length,
                        itemBuilder: (context, index) {
                          return buildPlaylistItem(state.playlists[index], context, audioViewModel);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget buildPlaylistItem(PlaylistItem playlist, BuildContext context, AudioPlayerViewModel audioViewModel) {
    return Container(
      margin: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Flexible(
                        child: Text(
                          playlist.title,
                          style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
                          softWrap: true,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      PopupMenuButton(
                        color: Colors.white,
                        surfaceTintColor: Colors.white,
                        icon: const Icon(Icons.more_vert, color: Colors.white),
                        onSelected: (value) {
                          if (value == 'rename') {
                            showDialog(
                              context: context,
                              builder: (context) => CustomDialog(
                                title: 'Rename Playlist',
                                hint: "Playlist Name",
                                onTap: (newName) {
                                  viewModel.renamePlaylist(playlist.id, newName);
                                },
                              ),
                            );
                          } else if (value == 'delete') {
                            viewModel.deletePlaylist(playlist.id);
                          }
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'rename',
                            child: Text('Rename'),
                          ),
                          const PopupMenuItem(
                            value: 'delete',
                            child: Text('Delete'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: () async {
                    GoRouter.of(context).push("/my_playlist_grid", extra: MyPlaylistsGridViewArgs(playlist, viewModel));
                  },
                  child: Text(
                    "See all",
                    style: TextStyle(color: Colors.grey[300], fontWeight: FontWeight.w500, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: playlist.audios.isEmpty ? 0 : 250,
            // Adjust height based on whether playlist has audios
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(left: 20),
              itemCount: playlist.audios.length + 1,
              itemBuilder: (context, index) {
                if (index == playlist.audios.length) {
                  return const SizedBox(width: 16);
                }
                return buildAudioItem(mapAudioToLightLanguageAudio(playlist.audios[index]), context, audioViewModel);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildAudioItem(LightLanguageAudioModel audio, BuildContext context, AudioPlayerViewModel audioViewModel) {
    return GestureDetector(
      onTap: () {
        List<LightLanguageAudioModel> audios = [];
        audios.add(audio);
        audioViewModel.populateAudioList(audios);
        audioViewModel.updateCurrentAudioState();
        audioViewModel.setAudioPlayer(
            audioViewModel.state.allAudioList[audioViewModel.state.currentAudioIndex].audioURL, false);
        GoRouter.of(context).push("/audio_player");
      },
      child: Container(
        width: 150,
        margin: const EdgeInsets.fromLTRB(0, 8, 16, 8),
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 3 / 4,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(0.0),
                child: CachedNetworkImage(
                  imageUrl: audio.image,
                  progressIndicatorBuilder: (context, url, downloadProgress) => Shimmer(
                      gradient: AppTheme.colors.linearLoading,
                      child: Container(color: Colors.white, width: 300, height: 400)),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  width: 300,
                  height: 400,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              audio.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 16, color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
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
