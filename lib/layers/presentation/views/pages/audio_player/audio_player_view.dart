import 'package:breathpacer/layers/presentation/views/pages/audio_player/audio_player_state.dart';
import 'package:breathpacer/layers/presentation/views/pages/audio_player/audio_player_view_model.dart';
import 'package:breathpacer/layers/presentation/views/pages/audio_player/widgets/vault_popup_selector.dart';
import 'package:breathpacer/layers/presentation/views/shared_widgets/star_magic/burger_drawer/burger_drawer_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:photo_view/photo_view.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../theme/app_theme.dart';
import '../../../../domain/models/light_language_audio.dart';
import 'widgets/playlist_popup_selector.dart';

class AudioPlayerView extends StatelessWidget {
  const AudioPlayerView({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<AudioPlayerViewModel>();
    final size = MediaQuery.of(context).size.width ;
    final height = MediaQuery.of(context).size.height ;

    return Container(
      decoration: BoxDecoration(gradient: AppTheme.colors.linearGradient),
      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          drawer: BurgerDrawerView(),
          appBar: AppBar(
            title: const Text("Audio Player"),
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
          body: BlocListener<AudioPlayerViewModel, AudioPlayerState>(
            listener: (context, state) {},
            child: BlocBuilder<AudioPlayerViewModel, AudioPlayerState>(
              bloc: viewModel,
              builder: (_, state) {
                return SafeArea(
                  top: false,
                  bottom: false,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        buildImage(state.imageUrl, context, size, height),
                        
                        Container(
                          height: height - (height*0.44) - kToolbarHeight - 96,
                          child: buildControls(context, viewModel, state, size)
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

void showImageDialog(BuildContext context, String imageURL) {
  showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return GestureDetector(
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Dialog(
          insetPadding: EdgeInsets.zero,
          backgroundColor: Colors.transparent,
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: PhotoView(
              imageProvider: CachedNetworkImageProvider(imageURL),
              backgroundDecoration: const BoxDecoration(color: Colors.transparent),
              minScale: PhotoViewComputedScale.contained * 0.8,
              maxScale: PhotoViewComputedScale.covered * 2,
            ),
          ),
        ),
      );
    },
  );
}

Widget buildImage(String imageURL, BuildContext context, double size,double height) {
  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
    width: size,
    // height: height*0.465,
    child: CachedNetworkImage(
      imageUrl: imageURL,
      progressIndicatorBuilder: (context, url, downloadProgress) => Shimmer(
          gradient: AppTheme.colors.linearLoading, child: Container(color: Colors.white, width: 300, height: 300)),
      errorWidget: (context, url, error) => const Icon(Icons.error),
      imageBuilder: (context, imageProvider) => GestureDetector(
        onTap: () {
          showImageDialog(context, imageURL);
        },
        child: Image(
          image: imageProvider,
          fit: BoxFit.cover,
        ),
      ),
      fit: BoxFit.cover,
      height: size,
      width: size,
    ),
  );
}
// Widget buildImage(String imageURL, BuildContext context, double size,double height) {
//   return Container(
//     margin: const EdgeInsets.symmetric(horizontal: 15,vertical: 10),
//     width: size,
//     height: height*0.465,
//     child: ClipRRect(
//       borderRadius: BorderRadius.circular(0.0),
//       child: CachedNetworkImage(
//         imageUrl: imageURL,
//         progressIndicatorBuilder: (context, url, downloadProgress) => Shimmer(
//             gradient: AppTheme.colors.linearLoading, child: Container(color: Colors.white, width: 300, height: 300)),
//         errorWidget: (context, url, error) => const Icon(Icons.error),
//         imageBuilder: (context, imageProvider) => GestureDetector(
//           onTap: () {
//             showImageDialog(context, imageURL);
//           },
//           child: Image(
//             image: imageProvider,
//             fit: BoxFit.cover,
//           ),
//         ),
//         fit: BoxFit.cover,
//       ),
//     ),
//   );
// }

Widget buildControls(BuildContext context, AudioPlayerViewModel viewModel, AudioPlayerState state, double size) {
  return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      width: size,
      // height: 250,
      child: Stack(
        fit: StackFit.expand,
        children: [
        // if (!state.isLoadingFavouriteAndDownload)
        //   buildFavouriteAndDownload(
        //       state.isAddedToPlaylist,
        //       state.isDownloaded,
        //       state.allAudioList[state.currentAudioIndex].audioURL,
        //       state.allAudioList[state.currentAudioIndex].id.toString(),
        //       viewModel,
        //       context
        //   ),
        if (state.isLoadingFavouriteAndDownload)
          const Align(
            alignment: Alignment.topCenter,
            child:  Padding(
                padding: EdgeInsets.only(top: 10),
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
          ),

        Column(
          children: [
            const Spacer(),
            if (!state.isLoadingFavouriteAndDownload)
              Container(
                child: buildFavouriteAndDownload(
                    state.isAddedToPlaylist,
                    state.isDownloaded,
                    state.allAudioList[state.currentAudioIndex].audioURL,
                    state.allAudioList[state.currentAudioIndex].id.toString(),
                    viewModel,
                    context
                ),
              ),

            Container(
              width: size,
              alignment: Alignment.center,
              margin: EdgeInsets.only(top: size*0.04, bottom: size*0.02),
              child: buildSlider(viewModel.state.currentSliderValue, viewModel, context)
            ),


            Container(
              width: size,
              alignment: Alignment.center,
              child: buildSkipAndSpeed(state.currentTime, state.timeLeft, state.playbackSpeed, viewModel)
            ),

            Container(
              margin: EdgeInsets.only(left: size*0.03, right: size*0.03,top: size*0.03),
              width: size,
              alignment: Alignment.center,
              child: buildMusicControlBar(state.isPaused, state.isShuffleOn, state.isLoopOn, state.currentAudioIndex,viewModel, state.allAudioList, state.shuffledAudioList)
            ),
            
          ],
        ),

        // Positioned(top: 30, right: 0, left: 0, child: buildSlider(viewModel.state.currentSliderValue, viewModel)),
        // Positioned(
        //     top: 60,
        //     right: 0,
        //     left: 0,
        //     child: buildSkipAndSpeed(state.currentTime, state.timeLeft, state.playbackSpeed, viewModel)),
        // Positioned(
        //     top: 160,
        //     right: 0,
        //     left: 0,
        //     child: buildMusicControlBar(state.isPaused, state.isShuffleOn, state.isLoopOn, state.currentAudioIndex,
        //         viewModel, state.allAudioList, state.shuffledAudioList)
        // )
      ]));
}

Widget buildFavouriteAndDownload(bool isFavorite, bool isOfflineEnabled, String url, String filename,
    AudioPlayerViewModel viewModel, BuildContext context) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      PlaylistsPopupSelector(
        title: 'Select Your Playlist',
        model: viewModel.state.playlistsNames,
        onTap: (selectedTitle) {},
        icon: Icon(
          Icons.favorite,
          color: isFavorite ? AppTheme.colors.pinkButton : Colors.white,
        ),
      ),
      VaultsPopupSelector(
        title: 'Select Your Vault',
        filename: filename,
        url: url,
        model: viewModel.state.vaultNames,
        onVaultTap: (selectedTitle) {},
        audio: viewModel.state.allAudioList[viewModel.state.currentAudioIndex],
      ),
    ],
  );
}

Widget buildSlider(double sliderValue, AudioPlayerViewModel viewModel, BuildContext context) {
  return SliderTheme(
    data: SliderTheme.of(context).copyWith(
      thumbColor: const Color.fromARGB(255, 21, 28, 112),
      overlayShape: SliderComponentShape.noThumb,
      // thumbShape: RoundSliderThumbShape(
      //   enabledThumbRadius: 7.0,  
      //   disabledThumbRadius: 7.0,
      // ),
    ),
    child: Slider(
      value: sliderValue,
      min: 0,
      max: 100,
      onChanged: (newRating) {
        viewModel.updateSliderValue(newRating, isDragging: true);
      },
      onChangeEnd: (newRating) {
        viewModel.updateSliderValue(newRating, isDragging: false);
      },
    ),
  );
}

Widget buildSkipAndSpeed(
    String currentTime, String timeLeft, double currentSpeedSelected, AudioPlayerViewModel viewModel) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: <Widget>[
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          const SizedBox(width: 10,),
          Row(
            children: [
              Container(
                width: 48,
                alignment: Alignment.center,
                child: Text(
                  currentTime,
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.replay_10_rounded, size: 30, color: Colors.white),
                onPressed: () {
                  viewModel.skipBackwards();
                },
              ),
            ],
          ),
          const Spacer(),
          Row(
            children: [
              IconButton(
                icon: const Icon(
                  Icons.forward_10_rounded,
                  size: 30,
                  color: Colors.white,
                ),
                onPressed: () {
                  viewModel.skipForward();
                },
              ),
              Container(
                width: 48,
                alignment: Alignment.center,
                child: Text(timeLeft, style: const TextStyle(color: Colors.white))
              ),
            ],
          ),
          const SizedBox(width: 12,),
        ],
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          buildSpeedButton(currentSpeedSelected, 0.3, (speed) {
            viewModel.setPlaybackSpeed(speed);
          }, isSelected: currentSpeedSelected == 0.3),
          buildSpeedButton(currentSpeedSelected, 0.5, (speed) {
            viewModel.setPlaybackSpeed(speed);
          }, isSelected: currentSpeedSelected == 0.5),
          buildSpeedButton(currentSpeedSelected, 1.0, (speed) {
            viewModel.setPlaybackSpeed(speed);
          }, isSelected: currentSpeedSelected == 1.0),
          buildSpeedButton(currentSpeedSelected, 2.0, (speed) {
            viewModel.setPlaybackSpeed(speed);
          }, isSelected: currentSpeedSelected == 2.0),
          buildSpeedButton(currentSpeedSelected, 3.0, (speed) {
            viewModel.setPlaybackSpeed(speed);
          }, isSelected: currentSpeedSelected == 3.0),
        ],
      ),
    ],
  );
}

Widget buildSpeedButton(double currentSpeedSelected, double speed, Function(double speed) onTap,
    {bool isSelected = false}) {
  return GestureDetector(
    onTap: () => onTap(speed),
    child: Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        border: Border.all(
          color: isSelected ? Colors.white : Colors.transparent,
        ),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Text(
        '${speed}x',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
    ),
  );
}

Widget buildMusicControlBar(
  bool isPaused,
  bool isShuffled,
  bool isLooped,
  int currentAudioIndex,
  AudioPlayerViewModel viewModel,
  List<LightLanguageAudioModel> allAudioList,
  List<LightLanguageAudioModel> shuffledAudioList,
) {
  // viewModel.state.isLoading ? null : viewModel.toggleIsPaused() ;
  return Padding(
    padding: const EdgeInsets.all(5.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 10,),
        SizedBox(
          child: Text(
            isShuffled ? shuffledAudioList[currentAudioIndex].title : allAudioList[currentAudioIndex].title,
            style: const TextStyle(
              color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold
            ),
            textAlign: TextAlign.center,
            softWrap: true,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: Icon(
                size: 30,
                isShuffled ? Icons.shuffle_on_rounded : Icons.shuffle,
                color: Colors.white,
              ),
              onPressed: () {
                viewModel.toggleIsShuffled();
              },
            ),
            IconButton(
              icon: const Icon(Icons.skip_previous, color: Colors.white, size: 35),
              onPressed: () {
                viewModel.playPreviousAudio();
              },
            ),
            viewModel.state.isLoading
                ? const CircularProgressIndicator(
                    color: Colors.white,
                  )
                : IconButton(
                    icon: Icon(
                      isPaused ? Icons.pause : Icons.play_arrow,
                      color: Colors.white,
                      size: 35,
                    ),
                    onPressed: () {
                      viewModel.toggleIsPaused();
                    },
                  ),
            IconButton(
              icon: const Icon(Icons.skip_next, color: Colors.white, size: 35),
              onPressed: () {
                viewModel.playNextAudio();
              },
            ),
            IconButton(
              icon: Icon(
                isLooped ? Icons.repeat_on_rounded : Icons.repeat,
                color: Colors.white,
                size: 30,
              ),
              onPressed: () {
                viewModel.toggleIsLooped();
              },
            ),
          ],
        ),
      ],
    ),
  );
}
