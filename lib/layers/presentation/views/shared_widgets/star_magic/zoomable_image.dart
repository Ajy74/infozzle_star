import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_view/photo_view.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../helpers/images.dart';
import '../../../../../theme/app_theme.dart';
import '../../../../domain/models/light_language_audio.dart';
import '../../pages/audio_player/audio_player_view_model.dart';
import '../../pages/my_playlists/my_playlists_view.dart';
import 'audio_item/audio_item_view_model.dart';

class ZoomableImageDialog extends StatelessWidget {
  final String imageUrl;
  final AudioPlayerViewModel audioViewModel;
  final AudioItemViewModel viewModel;

  const ZoomableImageDialog({super.key, required this.imageUrl, required this.audioViewModel, required this.viewModel});

  void _showImageDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.all(0),
            child: MediaQuery.removePadding(
              context: context,
              removeTop: true,
              removeBottom: true,
              child: Stack(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: PhotoView(
                      imageProvider: CachedNetworkImageProvider(imageUrl),
                      loadingBuilder: (context, event) => Shimmer(
                        gradient: AppTheme.colors.linearLoading,
                        child: Container(
                          color: Colors.white,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                      ),
                      errorBuilder: (context, error, stackTrace) => const Icon(Icons.error),
                      basePosition: Alignment.center,
                      backgroundDecoration: const BoxDecoration(
                        color: Colors.transparent,
                      ),
                      minScale: PhotoViewComputedScale.contained,
                      maxScale: PhotoViewComputedScale.covered * 2,
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        GestureDetector(
          onTap: () => _showImageDialog(context),
          child: AspectRatio(
            aspectRatio: 3 / 4,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(0.0),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                progressIndicatorBuilder: (context, url, downloadProgress) => Shimmer(
                    gradient: AppTheme.colors.linearLoading,
                    child: Container(color: Colors.white, width: 300, height: 400)),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        TextButton(
          child: Image.asset(Images.playButton, width: 64),
          onPressed: () {
            List<LightLanguageAudioModel> audios = [];
            audios.add(mapAudioToLightLanguageAudio(viewModel.state.audio));
            audioViewModel.populateAudioList(audios);
            audioViewModel.updateCurrentAudioState();
            audioViewModel.setAudioPlayer(
                audioViewModel.state.allAudioList[audioViewModel.state.currentAudioIndex].audioURL, false);

            GoRouter.of(context).push("/audio_player");
          },
        ),
      ],
    );
  }
}
