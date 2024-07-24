import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:breathpacer/layers/domain/models/blog_model.dart';
import 'package:breathpacer/layers/presentation/views/pages/blogs/widgets/blog_details_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../../theme/app_theme.dart';
import '../../shared_widgets/star_magic/burger_drawer/burger_drawer_view.dart';
import '../../shared_widgets/star_magic/extract_blogs.dart';
import 'blog_state.dart';
import 'blog_view_model.dart';

class BlogsView extends StatelessWidget {
  BlogsView({super.key});

  final BlogViewModel viewModel = BlogViewModel();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Blogs"),
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
          drawer: BurgerDrawerView(),
          body: BlocBuilder<BlogViewModel, BlogState>(
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
                        title: "Failed to fetch Blogs",
                        text: "An error occurred while fetching blogs, please try again.",
                      ),
                    ));
                state.showErrorMessage = false;
              }
              return SafeArea(
                top: true,
                bottom: true,
                child: Column(
                  children: [
                    if (state.isLoading)
                      const Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                    const SizedBox(height: 10),
                    Expanded(child: buildBlogList(state.blogList)),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget buildBlogList(List<BlogModel> blogList) {
    return ListView.builder(
      itemCount: blogList.length,
      itemBuilder: (context, index) {
        final blog = blogList[index];
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              GoRouter.of(context).push("/blog_details", extra: BlogDetailsArgs(blogList, index));
            },
            child: Card(
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(0))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(0.0),
                      topRight: Radius.circular(0.0),
                    ),
                    child: Stack(
                      children: [
                        CachedNetworkImage(
                          imageUrl: blog.image,
                          placeholder: (context, url) => Shimmer.fromColors(
                            baseColor: Colors.grey[300]!,
                            highlightColor: Colors.grey[100]!,
                            child: Container(
                              width: double.infinity,
                              height: 200.0, // Adjust height as needed
                              color: Colors.white,
                            ),
                          ),
                          errorWidget: (context, url, error) => const Icon(Icons.error),
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                        Positioned.fill(
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                GoRouter.of(context).push("/blog_details", extra: BlogDetailsArgs(blogList, index));
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          blog.title,
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          extractPlainText(blog.description),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
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
}
