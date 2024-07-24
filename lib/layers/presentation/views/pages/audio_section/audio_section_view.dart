import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../../theme/app_theme.dart';
import '../../../../../helpers/filter_options.dart';
import '../../../../domain/models/audio_section_model.dart';
import 'audio_section_state.dart';
import 'audio_section_view_model.dart';

class AudioSectionView extends StatelessWidget {
  AudioSectionView({super.key, required this.allItems, required this.title}) {
    viewModel.saveChallenge(allItems);
  }

  final AudioSectionViewModel viewModel = AudioSectionViewModel();
  final List<AudioSectionModel> allItems;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(gradient: AppTheme.colors.linearGradient),
      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(title),
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
          body: BlocBuilder<AudioSectionViewModel, AudioSectionState>(
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
                        title: "Failed to update",
                        text: "An error occurred while updating data, please try again.",
                      ),
                    ));
                state.showErrorMessage = false;
              }
              return Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        buildFilterButton(context),
                        const SizedBox(width: 10),
                        buildSortButton(),
                      ],
                    ),
                  ),
                  Expanded(child: buildCards(context)),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget buildFilterButton(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.white),
          surfaceTintColor: MaterialStateProperty.all(Colors.white),
          elevation: MaterialStateProperty.all(1)),
      onPressed: () {
        showDialog(
          context: context,
          builder: (context) => Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.15),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Material(
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    color: Colors.white,
                    width: MediaQuery.of(context).size.width - 20,
                    padding: const EdgeInsets.all(16.0),
                    child: FilterOptions(
                      onSelected: (filter) {
                        viewModel.setCurrentFiltersSelected(filter);
                        viewModel.onFilterSelected(context, filter);
                        viewModel.onSortSelected(viewModel.state.selectedSortLabel);
                      },
                      initialSelectedFilters: viewModel.state.selectedFilters,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
      child: SizedBox(
        height: 50,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(viewModel.state.selectedFilterLabel, style: const TextStyle(color: Colors.black)),
            const SizedBox(width: 10),
            const Icon(Icons.arrow_drop_down, color: Colors.black),
          ],
        ),
      ),
    );
  }

  Widget buildSortButton() {
    return Material(
      elevation: 1,
      borderRadius: BorderRadius.circular(60),
      child: DropdownButton2(
        hint: const Text(
          "Sort by likes",
          style: TextStyle(fontSize: 14, color: Colors.black),
        ),
        value: viewModel.state.selectedSortLabel.isEmpty ? null : viewModel.state.selectedSortLabel,
        onChanged: (String? newValue) {
          if (newValue != null) {
            viewModel.onSortSelected(newValue);
          }
        },
        items: viewModel.state.categories
            .map((sortOption) => DropdownMenuItem<String>(
                  value: sortOption,
                  child: Text(
                    sortOption,
                    style: const TextStyle(fontSize: 14),
                  ),
                ))
            .toList(),
        underline: Container(
          color: Colors.transparent,
        ),
        iconStyleData: const IconStyleData(iconEnabledColor: Colors.black),
        buttonStyleData: ButtonStyleData(
            height: 50,
            padding: const EdgeInsets.fromLTRB(10, 0, 20, 0),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(60))),
      ),
    );
  }

  Widget buildCards(BuildContext context) {
    var challenges = viewModel.state.allItems;

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.6,
          crossAxisSpacing: 30,
          mainAxisSpacing: 10,
        ),
        itemCount: challenges.length,
        itemBuilder: (context, index) {
          final challenge = challenges[index];
          return buildAudioItem(context, challenge, index, challenges);
        },
      ),
    );
  }

  Widget buildAudioItem(
      BuildContext context, AudioSectionModel audio, int index, List<AudioSectionModel> allAudioItems) {
    return GestureDetector(
      onTap: () {
        GoRouter.of(context).push("/audio_item", extra: audio);
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          AspectRatio(
            aspectRatio: 3 / 4,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(0)),
                  child: CachedNetworkImage(
                    imageUrl: audio.image,
                    placeholder: (context, url) => Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        color: Colors.white,
                      ),
                    ),
                    errorWidget: (context, url, error) => const Icon(Icons.error),
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
                Positioned(
                  bottom: 10,
                  left: 10,
                  right: 10,
                  child: Row(
                    children: [
                      GestureDetector(
                        child: Icon(Icons.thumb_up_rounded,
                            size: 20, color: audio.isLiked ? AppTheme.colors.pinkButton : Colors.white),
                        onTap: () {
                          viewModel.toggleLiked(audio, index, allAudioItems);
                        },
                      ),
                      const SizedBox(width: 4),
                      Text(audio.numOfLikes.toString(), style: const TextStyle(color: Colors.white)),
                      const Spacer(),
                      Text(audio.time, style: const TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              audio.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class AudioSectionArgs {
  //Used to get parameters through the extra in the router
  final List<AudioSectionModel> allItems;
  final String title;

  AudioSectionArgs(this.allItems, this.title);
}
