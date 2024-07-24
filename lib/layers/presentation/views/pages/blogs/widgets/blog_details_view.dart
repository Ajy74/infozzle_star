import 'package:breathpacer/layers/domain/models/video_model.dart';
import 'package:breathpacer/layers/presentation/views/shared_widgets/star_magic/custom_video_player.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../helpers/images.dart';
import '../../../../../../theme/app_theme.dart';
import '../../../../../domain/models/blog_model.dart';
import '../../../shared_widgets/star_magic/extract_blogs.dart';

class BlogDetailsView extends StatefulWidget {
  const BlogDetailsView({super.key, required this.blogs, required this.index});

  final List<BlogModel> blogs;
  final int index;

  @override
  BlogDetailsViewState createState() => BlogDetailsViewState();
}

class BlogDetailsViewState extends State<BlogDetailsView> {
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
            title: const Text("Blogs"),
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
                Image.asset(Images.healingBanner, width: double.infinity),
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(blog.title,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, color: AppTheme.colors.blueSlider, fontWeight: FontWeight.bold)),
          ),
          CustomVideos(
              videos: mapBlogToVideo(blog), textColor: Colors.transparent, startFullScreen: false, isYoutube: true),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text("Transcript",
                style: TextStyle(fontSize: 18, color: AppTheme.colors.blueSlider, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              extractPlainText(blog.description),
              style: TextStyle(fontSize: 16, color: Colors.grey[800]),
              textAlign: TextAlign.center,
            ),
          ),
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

class BlogDetailsArgs {
  final List<BlogModel> blogs;
  final int index;

  BlogDetailsArgs(this.blogs, this.index);
}
