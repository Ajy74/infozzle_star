import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:breathpacer/layers/domain/models/playlist_model.dart';
import 'package:breathpacer/layers/presentation/views/pages/playlists/playlists_state.dart';
import 'package:breathpacer/layers/presentation/views/pages/playlists/playlists_view_model.dart';
import 'package:breathpacer/layers/presentation/views/pages/playlists/widgets/playlist_grid_view.dart';
import 'package:breathpacer/layers/presentation/views/pages/playlists/widgets/playlist_list_view.dart';
import 'package:breathpacer/theme/app_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:recase/recase.dart';
import 'package:shimmer/shimmer.dart';

import '../../shared_widgets/star_magic/burger_drawer/burger_drawer_view.dart';
import '../audio_player/audio_player_view_model.dart';

class PlaylistsView extends StatelessWidget {
  PlaylistsView({super.key}) {
    viewModel.getUserPlaylists();
  }

  final PlaylistsViewModel viewModel = PlaylistsViewModel();

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
            title: const Text("Curated Playlists"),
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
          body: BlocBuilder<PlaylistsViewModel, PlaylistsState>(
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (state.isPlaylistsLoading)
                        const Padding(
                          padding: EdgeInsets.only(top: 20),
                          child: Center(
                            child: CircularProgressIndicator(color: Colors.white),
                          ),
                        ),
                      const SizedBox(height: 10),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: state.playlists.length,
                        itemBuilder: (context, index) {
                          return buildPlaylists(state.playlists[index], index, context, audioViewModel);
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

  Widget buildPlaylists(
      PlaylistModel playlist, int playlistIndex, BuildContext context, AudioPlayerViewModel audioViewModel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16),
              child: Text(
                ReCase(playlist.title).titleCase.toString(),
                style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w600),
              ),
            ),
            const Spacer(),
            TextButton(
                onPressed: () {
                  GoRouter.of(context)
                      .push("/playlist_grid", extra: PlaylistGridViewArgs(playlist.audios, playlist.title, viewModel));
                },
                child: Text(
                  "See all",
                  style: TextStyle(color: Colors.grey[300], fontWeight: FontWeight.w500, fontSize: 16),
                ))
          ],
        ),
        SizedBox(
          height: 250,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: playlist.audios.length > 5 ? 5 : playlist.audios.length,
            itemBuilder: (context, index) {
              if (index == playlist.audios.length) {
                return const SizedBox(width: 16);
              }

              return buildAudioItem(playlist.audios[index], context, audioViewModel, index == 0, playlist.title);
            },
          ),
        ),
      ],
    );
  }

  Widget buildAudioItem(PlaylistItem audio, BuildContext context, AudioPlayerViewModel audioViewModel, bool isFirstItem,
      String playlistName) {
    return GestureDetector(
      onTap: () async {
        GoRouter.of(context).push("/playlist_list", extra: PlaylistListViewArgs(audio, false));
      },
      child: Container(
        width: 150,
        margin: EdgeInsets.fromLTRB(isFirstItem ? 16 : 0, 8, 16, 8),
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
              style: const TextStyle(fontSize: 15, color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
