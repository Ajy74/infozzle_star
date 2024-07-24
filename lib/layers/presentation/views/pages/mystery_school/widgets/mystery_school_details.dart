import 'package:breathpacer/layers/domain/models/blog_model.dart';
import 'package:breathpacer/layers/presentation/views/shared_widgets/star_magic/custom_video_player.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../helpers/images.dart';
import '../../../../../../theme/app_theme.dart';
import '../../../../../domain/models/video_model.dart';
import '../../../shared_widgets/star_magic/extract_blogs.dart';

class MysterySchoolDetailsView extends StatefulWidget {
  const MysterySchoolDetailsView({super.key, required this.blogs, required this.index});

  final List<BlogModel> blogs;
  final int index;

  @override
  MysterySchoolDetailsViewState createState() => MysterySchoolDetailsViewState();
}

class MysterySchoolDetailsViewState extends State<MysterySchoolDetailsView> {
  late int currentIndex;

  @override
  void initState() {
    super.initState();
    currentIndex = widget.index;
  }

  @override
  Widget build(BuildContext context) {
    final BlogModel currentBlog = widget.blogs[currentIndex];
    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Mystery School"),
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
          body: SafeArea(
            top: true,
            bottom: true,
            child: Column(
              children: [
                Image.asset(Images.schoolBanner, width: double.infinity),
                const SizedBox(height: 20),
                Expanded(child: buildBlog(currentBlog)),
                buildNextPrevious(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildBlog(BlogModel blog) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(40),
            child: Column(
              children: [
                Text(
                  blog.title,
                  style: TextStyle(
                    color: AppTheme.colors.blueSchool,
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                Text(
                  extractPlainText(blog.description),
                  style: TextStyle(
                    color: AppTheme.colors.blueSchool,
                    fontSize: 18,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          CustomVideos(
            videos: mapBlogToVideo(blog),
            textColor: Colors.transparent,
            startFullScreen: false,
            isYoutube: false,
          ),
          const SizedBox(height: 10),
          Text(
            "Are you ready?\n\n"
            "Expect Transformation.\n\n"
            "See You on the Inside Beautiful\n\n"
            "Souls",
            style: TextStyle(
              color: AppTheme.colors.blueSchool,
              fontSize: 18,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 30),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Container(
              width: double.infinity,
              height: 5,
              decoration: BoxDecoration(
                gradient: AppTheme.colors.linearEvent,
              ),
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget buildNextPrevious(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Row(
        children: [
          GestureDetector(
            onTap: _goToPreviousBlog,
            child: Row(
              children: [
                Transform.scale(
                  scaleX: -1,
                  child: Icon(Icons.play_arrow, size: 40, color: AppTheme.colors.appBarColor),
                ),
                const Text("Previous"),
              ],
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: _goToNextBlog,
            child: Row(
              children: [
                const Text("Next"),
                Icon(Icons.play_arrow, size: 40, color: AppTheme.colors.appBarColor),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _goToNextBlog() {
    if (currentIndex < widget.blogs.length - 1) {
      setState(() {
        currentIndex++;
      });
    }
  }

  void _goToPreviousBlog() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
      });
    }
  }

  List<VideoModel> mapBlogToVideo(BlogModel blog) {
    List<VideoModel> video = [];
    video.add(VideoModel(
        title: blog.title, videoURL: extractYouTubeLink(blog.description), image: blog.image, description: ""));
    return video;
  }
}

class MysterySchoolDetailsArgs {
  final List<BlogModel> blogs;
  final int index;

  MysterySchoolDetailsArgs(this.blogs, this.index);
}
