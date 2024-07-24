import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pod_player/pod_player.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../domain/models/video_model.dart';

class CustomVideoViewer extends StatefulWidget {
  const CustomVideoViewer({
    super.key,
    required this.videoURL,
    required this.image,
    required this.startFullScreen,
    required this.isYoutube,
  });

  final String videoURL;
  final String image;
  final bool startFullScreen;
  final bool isYoutube;

  @override
  State<CustomVideoViewer> createState() => _CustomVideoViewerState();
}

class _CustomVideoViewerState extends State<CustomVideoViewer> {
  late final PodPlayerController controller;
  bool isPlaying = false;
  bool isThumbnailLoaded = false;
  bool showThumbnail = true;

  @override
  void initState() {
    super.initState();
  }

  void initializePlayer() async {
    try {
      if (!mounted) return;
      controller = PodPlayerController(
        podPlayerConfig: const PodPlayerConfig(
          autoPlay: false,
          isLooping: false,
        ),
        playVideoFrom:
            widget.isYoutube ? PlayVideoFrom.youtube(widget.videoURL) : PlayVideoFrom.network(widget.videoURL),
      )..initialise();
      setState(() {
        isPlaying = true;
        showThumbnail = false; // Switch to video player once initialized
      });
    } catch (e) {
      print('Error initializing video player: $e');
    }
  }

  @override
  void dispose() {
    if (isPlaying) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double size = MediaQuery.of(context).size.width ;

    return Container(
      padding: EdgeInsets.only(top: size*0.049,right: size*0.045, left: size*0.045,bottom: size*0.02),
      child: isPlaying
          ? ClipRRect(
              borderRadius: BorderRadius.circular(0),
              child: Stack(
                children: [
                  PodVideoPlayer(
                    podProgressBarConfig: const PodProgressBarConfig(
                      padding: EdgeInsets.fromLTRB(15, 0, 15, 15),
                      circleHandlerColor: Colors.blue,
                    ),
                    controller: controller,
                  ),
                ],
              ),
            )
          : Stack(
              alignment: Alignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(0),
                  child: CachedNetworkImage(
                    imageUrl: widget.image,
                    placeholder: (context, url) => Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        color: Colors.white,
                      ),
                    ),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                    fit: BoxFit.cover,
                    height: 200,
                    width: double.infinity,
                    imageBuilder: (context, imageProvider) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        setState(() {
                          isThumbnailLoaded = true;
                        });
                      });
                      return Image(
                        image: imageProvider,
                        fit: BoxFit.cover,
                        height: 200,
                        width: double.infinity,
                      );
                    },
                  ),
                ),
                if (isThumbnailLoaded && showThumbnail)
                  IconButton(
                    icon: const Icon(Icons.play_circle_fill, size: 64, color: Colors.white),
                    onPressed: initializePlayer,
                  ),
              ],
            ),
    );
  }
}

class CustomVideos extends StatelessWidget {
  const CustomVideos(
      {super.key,
      required this.videos,
      required this.textColor,
      required this.startFullScreen,
      required this.isYoutube});

  final List<VideoModel> videos;
  final Color textColor;
  final bool startFullScreen;
  final bool isYoutube;

  @override
  Widget build(BuildContext context) {
    final double size = MediaQuery.of(context).size.width ;

    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemCount: videos.length,
      itemBuilder: (context, index) {
        final video = videos[index];
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CustomVideoViewer(
              videoURL: video.videoURL,
              image: video.image,
              startFullScreen: startFullScreen,
              isYoutube: isYoutube,
            ),
            Container(
              width: size,
              margin: EdgeInsets.symmetric(horizontal: size*0.045),
              child: Text(
                video.title,
                style: TextStyle(
                  fontSize: size*0.045,
                  fontWeight: FontWeight.bold,
                  color: textColor,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
