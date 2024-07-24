import 'package:breathpacer/layers/presentation/views/pages/audio_player/audio_player_state.dart';
import 'package:breathpacer/theme/app_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../navigation/router.dart';
import '../audio_player_view_model.dart';

class MiniPlayerWidget extends StatelessWidget {
  const MiniPlayerWidget({super.key, required this.currentRoute, required this.router});

  final ValueNotifier<String> currentRoute;
  final GetRouter router;

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<AudioPlayerViewModel>();

    return ValueListenableBuilder<String>(
      valueListenable: currentRoute,
      builder: (context, route, child) {
        if (route == '/home') {
          viewModel.setBottomPadding(85.0);
        } else if (route == "/audio_player") {
          viewModel.setBottomPadding(-85.0);
          //viewModel.hideMiniPlayer();
        } else {
          viewModel.setBottomPadding(MediaQuery.of(context).padding.bottom);
        }

        return BlocBuilder<AudioPlayerViewModel, AudioPlayerState>(
          bloc: viewModel,
          builder: (context, state) {
            if (state.showMiniPlayer && route != "/audio_player") {
              return Stack(
                children: [
                  Positioned(
                    bottom: viewModel.state.bottomPadding,
                    left: 0,
                    right: 0,
                    child: Dismissible(
                      key: const Key('miniPlayer'),
                      direction: DismissDirection.horizontal,
                      onDismissed: (direction) {
                        viewModel.stopAndHideMiniPlayer();
                        viewModel.reset();
                      },
                      child: Material(
                        color: Colors.transparent,
                        child: GestureDetector(
                          onTap: () {
                            router.router.push("/audio_player");
                          },
                          child: Container(
                            decoration: const BoxDecoration(color: Colors.white),
                            padding: const EdgeInsets.fromLTRB(15, 8, 8, 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                LinearProgressIndicator(
                                  value: state.currentSliderValue / 100,
                                  backgroundColor: Colors.grey[300],
                                  valueColor: AlwaysStoppedAnimation<Color>(AppTheme.colors.blueSlider),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(0.0),
                                      child: CachedNetworkImage(
                                        imageUrl: state.isShuffleOn
                                            ? state.shuffledAudioList[state.currentAudioIndex].image
                                            : state.allAudioList[state.currentAudioIndex].image,
                                        progressIndicatorBuilder: (context, url, downloadProgress) => Shimmer(
                                            gradient: AppTheme.colors.linearLoading,
                                            child: Container(color: Colors.white, width: 50, height: 50)),
                                        errorWidget: (context, url, error) => const Icon(Icons.error),
                                        width: 50,
                                        height: 50,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        state.isShuffleOn
                                            ? state.shuffledAudioList[state.currentAudioIndex].title
                                            : state.allAudioList[state.currentAudioIndex].title,
                                        style: const TextStyle(color: Colors.black),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.skip_previous, color: AppTheme.colors.blueSlider),
                                      onPressed: viewModel.playPreviousAudio,
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        state.isPaused ? Icons.pause : Icons.play_arrow,
                                        color: AppTheme.colors.blueSlider,
                                      ),
                                      onPressed: viewModel.toggleIsPaused,
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.skip_next, color: AppTheme.colors.blueSlider),
                                      onPressed: viewModel.playNextAudio,
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.close, color: AppTheme.colors.blueSlider),
                                      onPressed: () {
                                        viewModel.stopAndHideMiniPlayer();
                                        viewModel.reset();
                                      },
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return const SizedBox.shrink();
            }
          },
        );
      },
    );
  }
}
