import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:breathpacer/layers/domain/models/blog_model.dart';
import 'package:breathpacer/layers/presentation/views/pages/high_vibration/high_vibration_state.dart';
import 'package:breathpacer/layers/presentation/views/pages/high_vibration/high_vibration_view_model.dart';
import 'package:breathpacer/layers/presentation/views/pages/high_vibration/widgets/high_vibration_details_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../../theme/app_theme.dart';
import '../../shared_widgets/star_magic/burger_drawer/burger_drawer_view.dart';
import '../../shared_widgets/star_magic/extract_blogs.dart';
import '../../shared_widgets/star_magic/search_bar.dart';

class HighVibrationView extends StatelessWidget {
  HighVibrationView({super.key});

  final HighVibrationViewModel viewModel = HighVibrationViewModel();

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
      drawer: BurgerDrawerView(),
      body: BlocBuilder<HighVibrationViewModel, HighVibrationState>(
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
          return Column(
            children: [
              CustomSearchBar(
                controller: viewModel.controller,
                color: AppTheme.colors.appBarColor,
                isCenter: false,
                hintText: 'Search High Nutrition Food',
                onChanged: (_) {
                  viewModel.updateSearchText();
                },
                isTappable: true,
              ),
              if (state.isLoading)
                const Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              Expanded(child: buildRecipeList(state.blogList, size)),
            ],
          );
        },
      ),
    );
  }

  Widget buildRecipeList(List<BlogModel> foodList, double size) {
    return ListView.builder(
      itemCount: foodList.length,
      itemBuilder: (context, index) {
        final recipe = foodList[index];
        return Padding(
          padding: EdgeInsets.symmetric(horizontal:size*0.03,vertical: index==0 ?size*0.02 : 0),
          child: GestureDetector(
            onTap: () {
              GoRouter.of(context).push("/high_vibration_details", extra: HighVibrationDetailsArgs(foodList, index));
            },
            child: Card(
              shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(0))),
              surfaceTintColor: Colors.white,
              shadowColor: Colors.transparent,
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
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
                      height: size*0.5,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical :size*0.02),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          recipe.title,
                          style: TextStyle(
                            fontSize: size*0.045,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                
                        Text(
                          parseHtmlToRecipeModel(recipe.description),
                          style: TextStyle(
                            fontSize: size*0.039,
                            color: Colors.black,
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
