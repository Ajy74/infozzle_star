import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:breathpacer/layers/domain/models/resources_model.dart';
import 'package:breathpacer/layers/presentation/views/pages/resources/resources_state.dart';
import 'package:breathpacer/layers/presentation/views/pages/resources/resources_view_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../../theme/app_theme.dart';
import '../../shared_widgets/star_magic/burger_drawer/burger_drawer_view.dart';
import '../audio_section/audio_section_view.dart';

class ResourcesView extends StatelessWidget {
  ResourcesView({super.key});

  final ResourcesViewModel viewModel = ResourcesViewModel();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppTheme.colors.linearGradient),
      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Resources Section"),
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
          body: BlocBuilder<ResourcesViewModel, ResourcesState>(
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
                        title: "Failed to fetch Resources",
                        text: "An error occurred while fetching resoruces, please try again.",
                      ),
                    ));
                state.showErrorMessage = false;
              }
              return SafeArea(
                top: true,
                bottom: true,
                child: Column(
                  children: [
                    buildDropDown(state.categories, state.selectedCategory),
                    if (state.isLoading)
                      const Padding(
                        padding: EdgeInsets.only(top: 20),
                        child: Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        ),
                      ),
                    Expanded(child: buildResourceList(state.resourceList)),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget buildDropDown(List<String> categories, String selectedCategory) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: Colors.grey),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            isExpanded: true,
            dropdownColor: Colors.white,
            value: selectedCategory,
            onChanged: (String? newValue) {
              if (newValue != null) {
                viewModel.filterResourceList(newValue);
              }
            },
            items: categories.map<DropdownMenuItem<String>>((String category) {
              return DropdownMenuItem<String>(
                value: category,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(category),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Widget buildResourceList(List<ResourcesModel> resourceList) {
    return ListView.builder(
      itemCount: resourceList.length,
      itemBuilder: (context, index) {
        final resource = resourceList[index];
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 0.0),
          child: GestureDetector(
            onTap: () async {
              if (resource.isActive) {
                var audios = await viewModel.getAudios(resource.id);
                GoRouter.of(context).push("/audio_section", extra: AudioSectionArgs(audios, "Resources Section"));
              } else {
                Future.microtask(() => ArtSweetAlert.show(
                      context: context,
                      artDialogArgs: ArtDialogArgs(
                        dialogDecoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        type: ArtSweetAlertType.info,
                        title: "Not Available",
                        text:
                            "This section is available for Infinity Members who are IW19 - Grand Central Sun, Council Of Light Exploration. Please contact us on info@starmagichealing .com for access",
                      ),
                    ));
              }
            },
            child: Card(
              elevation: 0,
              color: Colors.transparent,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(0.0),
                      topRight: Radius.circular(0.0),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: resource.image,
                      placeholder: (context, url) => Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          height: 200.0,
                          color: Colors.white,
                        ),
                      ),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                      height: 200.0,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          resource.title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4.0),
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
