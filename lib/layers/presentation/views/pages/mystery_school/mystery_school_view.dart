import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:breathpacer/layers/domain/models/blog_model.dart';
import 'package:breathpacer/layers/presentation/views/pages/mystery_school/mystery_school_state.dart';
import 'package:breathpacer/layers/presentation/views/pages/mystery_school/mystery_school_view_model.dart';
import 'package:breathpacer/layers/presentation/views/pages/mystery_school/widgets/mystery_school_details.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../../theme/app_theme.dart';
import '../../shared_widgets/star_magic/burger_drawer/burger_drawer_view.dart';
import '../../shared_widgets/star_magic/extract_blogs.dart';

class MysterySchoolView extends StatelessWidget {
  MysterySchoolView({super.key});

  final MysterySchoolViewModel viewModel = MysterySchoolViewModel();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.white),
      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Mystery School"),
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
          body: BlocBuilder<MysterySchoolViewModel, MysterySchoolState>(
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
                        title: "Failed to fetch Data",
                        text: "An error occurred while fetching data, please try again.",
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
                    Expanded(child: buildVideoList(state.blogs)),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget buildVideoList(List<BlogModel> videoList) {
    return ListView.builder(
      itemCount: videoList.length,
      itemBuilder: (context, index) {
        final video = videoList[index];
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: GestureDetector(
            onTap: () {
              GoRouter.of(context).push(
                "/mystery_school_details",
                extra: MysterySchoolDetailsArgs(videoList, index),
              );
            },
            child: Card(
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(0))),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    child: CachedNetworkImage(
                      imageUrl: video.image,
                      placeholder: (context, url) => Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          height: 200.0,
                          color: Colors.white,
                        ),
                      ),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          video.title,
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4.0),
                        Text(
                          extractPlainText(video.description),
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.grey[600],
                          ),
                          maxLines: 3,
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
