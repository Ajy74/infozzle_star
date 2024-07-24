import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:breathpacer/theme/app_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:recase/recase.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../domain/models/audio_section_model.dart';
import '../../../../../domain/models/playlist_model.dart';
import '../my_playlists_view_model.dart';

class MyPlaylistsGridView extends StatefulWidget {
  const MyPlaylistsGridView({super.key, required this.playlist, required this.viewModel});

  final PlaylistItem playlist;
  final MyPlaylistsViewModel viewModel;

  @override
  MyPlaylistsGridViewState createState() => MyPlaylistsGridViewState();
}

class MyPlaylistsGridViewState extends State<MyPlaylistsGridView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ReCase(widget.playlist.title).titleCase.toString()),
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
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        decoration: BoxDecoration(gradient: AppTheme.colors.linearGradient),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Playlists", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 20)),
            const SizedBox(height: 20),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, crossAxisSpacing: 10, mainAxisSpacing: 10, childAspectRatio: 2 / 3),
                itemCount: widget.playlist.audios.length,
                itemBuilder: (context, index) {
                  return buildGridItem(widget.playlist.audios[index], context, index);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildGridItem(AudioSectionModel item, BuildContext context, int index) {
    return GestureDetector(
      onTap: () async {
        GoRouter.of(context).push("/audio_item", extra: item);
      },
      child: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: AspectRatio(
                  aspectRatio: 3 / 4,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(0.0),
                    child: CachedNetworkImage(
                      imageUrl: item.image,
                      progressIndicatorBuilder: (context, url, downloadProgress) =>
                          Shimmer(gradient: AppTheme.colors.linearLoading, child: Container(color: Colors.white)),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                item.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 15, color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
            ],
          ),
          Positioned(
              top: 0,
              right: 0,
              child: TextButton(
                child: Icon(Icons.favorite, color: AppTheme.colors.pinkButton),
                onPressed: () {
                  ArtSweetAlert.show(
                      context: context,
                      artDialogArgs: ArtDialogArgs(
                          dialogDecoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                          denyButtonText: "No",
                          confirmButtonText: "Yes",
                          onDeny: () {
                            Navigator.pop(context);
                          },
                          onConfirm: () {
                            setState(() {
                              widget.viewModel.removeFromPlaylist(item.id, [widget.playlist.id], item.title);
                              widget.playlist.audios.removeAt(index);
                            });
                            Navigator.pop(context);
                          },
                          type: ArtSweetAlertType.question,
                          title: "Delete from Playlist",
                          text: "Are you sure you want to remove ${item.title} from playlist?"));
                },
              ))
        ],
      ),
    );
  }
}

class MyPlaylistsGridViewArgs {
  final PlaylistItem playlist;
  final MyPlaylistsViewModel viewModel;

  MyPlaylistsGridViewArgs(this.playlist, this.viewModel);
}
