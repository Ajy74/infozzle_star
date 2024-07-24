import 'package:breathpacer/layers/presentation/views/pages/playlists/widgets/playlist_list_view.dart';
import 'package:breathpacer/theme/app_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:recase/recase.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../domain/models/playlist_model.dart';
import '../playlists_view_model.dart';

class PlaylistGridView extends StatelessWidget {
  const PlaylistGridView({super.key, required this.items, required this.title, required this.viewModel});

  final List<PlaylistItem> items;
  final String title;
  final PlaylistsViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(ReCase(title).titleCase.toString()),
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
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return buildGridItem(items[index], context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildGridItem(PlaylistItem item, BuildContext context) {
    return GestureDetector(
      onTap: () async {
        GoRouter.of(context).push("/playlist_list", extra: PlaylistListViewArgs(item, false));
      },
      child: Column(
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
    );
  }
}

class PlaylistGridViewArgs {
  // Used to get parameters through the extra in the router
  final List<PlaylistItem> items;
  final String title;
  final PlaylistsViewModel viewModel;

  PlaylistGridViewArgs(this.items, this.title, this.viewModel);
}
