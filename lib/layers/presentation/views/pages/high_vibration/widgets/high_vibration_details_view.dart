import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../../theme/app_theme.dart';
import '../../../../../domain/models/blog_model.dart';
import '../../../shared_widgets/star_magic/extract_blogs.dart';

class HighVibrationDetailsView extends StatefulWidget {
  const HighVibrationDetailsView({super.key, required this.recipes, required this.index});

  final List<BlogModel> recipes;
  final int index;

  @override
  HighVibrationDetailsViewState createState() => HighVibrationDetailsViewState();
}

class HighVibrationDetailsViewState extends State<HighVibrationDetailsView> {
  late int currentIndex;

  @override
  Widget build(BuildContext context) {
    final double size = MediaQuery.of(context).size.width ;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("High Vibration Nutrition (HVN)"),
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
      body: Column(
        children: [Expanded(child: buildRecipe(widget.recipes[currentIndex], size)), buildNextPrevious(context)],
      ),
    );
  }

  Widget buildRecipe(BlogModel recipe, double size) {
    print("====>>>recipe<<<");
    print(recipe.description);

    return SingleChildScrollView(
      child: Padding(
        padding:  EdgeInsets.all(size*0.045),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Center(
              child: Text(
                recipe.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: size*0.062,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: size*0.05),
            Center(
              child: ClipRRect(
                child: CachedNetworkImage(
                  imageUrl: recipe.image,
                  placeholder: (context, url) => Shimmer.fromColors(
                    baseColor: Colors.grey[300]!,
                    highlightColor: Colors.grey[100]!,
                    child: Container(
                      height: size*0.5,
                      color: Colors.white,
                    ),
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  width: double.infinity,
                  fit: BoxFit.cover,
                  height: size*0.7
                ),
              ),
            ),
            SizedBox(height: size*0.045),
            Center(
              child: Text(
                parseHtmlToRecipeModel(recipe.description),
                style: TextStyle(
                  fontSize: size*0.045, fontWeight: FontWeight.bold,
                  color: Colors.black.withOpacity(.7)
                ),
              ),
              // child: Html(data: recipe.description),
            ),
            Center(
              // child: Html(
              //   data: """
              //   <div style="text-align: center;">
              //     ${preprocessHtml(recipe.description)}
              //     </div>
              //     """,
              //   style: {
              //     "ul": Style(
              //         listStylePosition: ListStylePosition.inside, padding: HtmlPaddings.zero, margin: Margins.zero),
              //     "li": Style(padding: HtmlPaddings.zero, margin: Margins.zero, fontSize: FontSize(16.0)),
              //     "p": Style(fontSize: FontSize(16.0)),
              //     ".p8": Style(
              //       fontSize: FontSize(20.0),
              //       color: Colors.black87,
              //     ),
              //     ".p6": Style(
              //       fontSize: FontSize(20.0),
              //       color: Colors.black87,
              //     ),
              //   },
              // ),
              child: Html(data: preprocessHtml(recipe.description))
            ),
          ],
        ),
      ),
    );
  }

  Widget buildNextPrevious(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Row(
        children: [
          GestureDetector(
            onTap: _goToPreviousRecipe,
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
            onTap: _goToNextRecipe,
            child: Row(
              children: [
                const Text("Next"),
                Icon(Icons.play_arrow, size: 40, color: AppTheme.colors.appBarColor),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    currentIndex = widget.index;
  }

  void _goToNextRecipe() {
    if (currentIndex < widget.recipes.length - 1) {
      setState(() {
        currentIndex++;
      });
    }
  }

  void _goToPreviousRecipe() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
      });
    }
  }

  String preprocessHtml(String html) {
    final regex = RegExp(r'^<p class="p2">.*?<\/p>');
    return html.replaceFirst(regex, '');
  }
}

class HighVibrationDetailsArgs {
  //Used to get parameters through the extra in the router
  final List<BlogModel> recipes;
  final int index;

  HighVibrationDetailsArgs(this.recipes, this.index);
}
