import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:breathpacer/layers/domain/models/meditation_model.dart';
import 'package:breathpacer/layers/presentation/views/pages/meditation/meditation_state.dart';
import 'package:breathpacer/layers/presentation/views/shared_widgets/star_magic/search_bar.dart';
import 'package:breathpacer/theme/app_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:recase/recase.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../helpers/images.dart';
import '../../../../domain/models/audio_section_model.dart';
import '../../shared_widgets/star_magic/burger_drawer/burger_drawer_view.dart';
import '../audio_player/audio_player_view_model.dart';
import '../audio_section/audio_section_view.dart';
import 'meditation_view_model.dart';

class MeditationView extends StatelessWidget {
  MeditationView({super.key});

  final MeditationViewModel viewModel = MeditationViewModel();

  @override
  Widget build(BuildContext context) {
    final double size = MediaQuery.of(context).size.width ;
    final audioViewModel = context.read<AudioPlayerViewModel>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: const Text("Meditation Library"),
        titleTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: AppTheme.colors.appBarColor,
        actions: [
          IconButton(
              icon: const Icon(Icons.home_filled),
              onPressed: () {
                context.go("/home");
              }),
        ],
      ),
      drawer: BurgerDrawerView(),
      body: Container(
        width: size,
        height: double.maxFinite,
        decoration: BoxDecoration(gradient: AppTheme.colors.linearGradient),
        child: BlocBuilder<MeditationViewModel, MeditationState>(
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
                        title: state.errorTitle,
                        text: state.errorMessage,
                      ),
                    ));
                state.showErrorMessage = false;
              }

              if (state.isLoading) {
                return Container(
                  color: Colors.transparent,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                          color: AppTheme.colors.transparentGrey,
                        ),
                        child: const Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                );
              }
              
              // return ListView(
              //   children: [
              //     buildTopBar(context, size),
              //     SizedBox(height: size*0.08),

              //     if (state.currentSearchText.isEmpty)
              //       Container(
              //         width: size,
              //         alignment: Alignment.center,
              //         child: Text(
              //           "Meditations Categories",
              //           style: TextStyle(
              //             color: Colors.white, fontWeight: FontWeight.w600, fontSize: size*0.05
              //           )
              //         ),
              //       ),

              //     SizedBox(height: size*0.03),

              //     state.currentSearchText.isEmpty
              //         ? buildMeditationList(state.meditations, audioViewModel, size)
              //         : SizedBox(
              //             height: MediaQuery.of(context).size.height * 0.7,
              //             child: buildSearchResults(state.filteredAudios, audioViewModel, size)
              //           ),
              //   ],
              // );

              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        buildTopBar(context, size),
                        SizedBox(height: size * 0.08),
                        if (state.currentSearchText.isEmpty)
                          Container(
                            width: size,
                            alignment: Alignment.center,
                            child: Text(
                              "Meditations Categories",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: size * 0.05,
                              ),
                            ),
                          ),
                        SizedBox(height: size * 0.03),
                      ],
                    ),
                  ),
                  if (state.currentSearchText.isEmpty)
                    buildMeditationListSliver(state.meditations, audioViewModel, size)
                  else
                    buildSearchResultsSliver(state.filteredAudios, audioViewModel, size),
                ],
              );
          },
        ),
      ),
    );
  }

  Widget buildTopBar(BuildContext context, double size) {
    return Padding(
      padding: EdgeInsets.only(top: size*0.1),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: size*0.06),
            width: size,
            child: Column(
              children: [
                CustomSearchBar(
                    controller: viewModel.searchController,
                    hintText: "Search Meditations",
                    isCenter: true,
                    color: Colors.transparent,
                    onChanged: (_) {
                      viewModel.updateSearchText();
                    },
                    isTappable: !viewModel.state.isLoading && (viewModel.state.isActive || !viewModel.state.isGuest)
                ),

                SizedBox(height: size*0.03),

                SizedBox(
                  width: size,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          if (viewModel.state.isLoading) {
                          } else if (!viewModel.state.isActive || viewModel.state.isGuest) {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  surfaceTintColor: Colors.transparent,
                                  backgroundColor: Colors.transparent,
                                  content: Stack(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(7.0),
                                        child: Container(
                                          decoration:
                                              BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(0)),
                                          padding: const EdgeInsets.fromLTRB(24.0, 10.0, 24.0, 10.0),
                                          child: const Padding(
                                            padding: EdgeInsets.only(top: 20.0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  "Some sections are only accessible to Infinity Members. Please update your membership from the website.",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(fontSize: 18),
                                                ),
                                                SizedBox(height: 20),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        right: 0.0,
                                        top: 0.0,
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Align(
                                              alignment: Alignment.topRight,
                                              child: Image.asset(Images.xButton, width: 25, height: 25)),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          } else {
                            GoRouter.of(context).push(
                              "/audio_section",
                              extra: AudioSectionArgs(
                                await viewModel.getAllMeditations(true),
                                "Meditations Library",
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.colors.meditationColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                        ),
                        child: const Text(
                          'Browse All',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      SizedBox(width: size*0.05),
                      ElevatedButton(
                        onPressed: () {
                          if (!viewModel.state.isActive || viewModel.state.isGuest) {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  surfaceTintColor: Colors.transparent,
                                  backgroundColor: Colors.transparent,
                                  content: Stack(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(7.0),
                                        child: Container(
                                          decoration:
                                              BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(0)),
                                          padding: const EdgeInsets.fromLTRB(24.0, 10.0, 24.0, 10.0),
                                          child: const Padding(
                                            padding: EdgeInsets.only(top: 20.0),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Text(
                                                  "Some sections are only accessible to Infinity Members. Please update your membership from the website.",
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(fontSize: 18),
                                                ),
                                                SizedBox(height: 20),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        right: 0.0,
                                        top: 0.0,
                                        child: GestureDetector(
                                          onTap: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Align(
                                              alignment: Alignment.topRight,
                                              child: Image.asset(Images.xButton, width: 25, height: 25)),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          } else {
                            GoRouter.of(context).push("/my_playlists");
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.colors.pinkButton,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50.0),
                          ),
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.favorite,
                              color: Colors.white,
                              size: 17,
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Playlist',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget buildSearchResults(List<AudioSectionModel> audios, AudioPlayerViewModel audioViewModel, double size) {
  //   final filteredAudios = audios.where((audio) {
  //     final searchText = viewModel.state.currentSearchText.toLowerCase();
  //     final audioTitle = audio.title.toLowerCase();
  //     return audioTitle.contains(searchText);
  //   }).toList();

  //   if (filteredAudios.isEmpty) {
  //     return const Center(
  //       child: Text(
  //         'No results found',
  //         style: TextStyle(color: Colors.white, fontSize: 16),
  //       ),
  //     );
  //   }

  //   return Padding(
  //     padding: EdgeInsets.fromLTRB(size*0.058, 0, size*0.058, 0),
  //     child: GridView.builder(
  //       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
  //         crossAxisCount: 2,
  //         childAspectRatio: 0.6,
  //         crossAxisSpacing: 25,
  //         mainAxisSpacing: 16,
  //       ),
  //       physics: NeverScrollableScrollPhysics(),
  //       itemCount: filteredAudios.length,
  //       itemBuilder: (context, index) {
  //         final audio = filteredAudios[index];
  //         return buildAudioItem2(context, audio, index, filteredAudios, size);
  //       },
  //     ),
  //   );
  // }

Widget buildSearchResultsSliver(List<AudioSectionModel> audios, AudioPlayerViewModel audioViewModel, double size) {
    final filteredAudios = audios.where((audio) {
      final searchText = viewModel.state.currentSearchText.toLowerCase();
      final audioTitle = audio.title.toLowerCase();
      return audioTitle.contains(searchText);
    }).toList();

    if (filteredAudios.isEmpty) {
      return const SliverToBoxAdapter(
        child:  Center(
          child: Text(
            'No results found',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      );
    }

    return SliverPadding(
      padding: EdgeInsets.fromLTRB(size * 0.058, 0, size * 0.058, 0),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.6,
          crossAxisSpacing: 25,
          mainAxisSpacing: 16,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final audio = filteredAudios[index];
            return buildAudioItem2(context, audio, index, filteredAudios, size);
          },
          childCount: filteredAudios.length,
        ),
      ),
    );
  }

SliverList buildMeditationListSliver(List<MeditationModel> meditations, AudioPlayerViewModel audioViewModel, double size) {
  return SliverList(
    delegate: SliverChildBuilderDelegate(
      (context, index) {
        return buildVaultItem(meditations[index], context, audioViewModel, index, size);
      },
      childCount: meditations.length,
    ),
  );
}


  // Widget buildMeditationList(List<MeditationModel> meditations, AudioPlayerViewModel audioViewModel, double size) {
  //   return SizedBox(
  //     child: ListView.builder(
  //       padding: EdgeInsets.symmetric(vertical: size*0.03),
  //       shrinkWrap: true,
  //       physics: const NeverScrollableScrollPhysics(),
  //       itemCount: meditations.length,
  //       itemBuilder: (context, index) {
  //         return buildVaultItem(meditations[index], context, audioViewModel, index, size);
  //       },
  //     ),
  //   );
  // }

  

  Widget buildVaultItem(
      MeditationModel meditation, BuildContext context, AudioPlayerViewModel audioViewModel, int index, double size) {
    bool showBackground = index % 2 == 0;

    return Container(
      decoration: showBackground
          ? BoxDecoration(
              color: AppTheme.colors.transparentGrey,
            )
          : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.only(left: size*0.045,right: size*0.01),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    ReCase(meditation.title).titleCase.toString(),
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: size*0.05,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    if (!viewModel.state.isActive || viewModel.state.isGuest) {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            surfaceTintColor: Colors.transparent,
                            backgroundColor: Colors.transparent,
                            content: Stack(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(7.0),
                                  child: Container(
                                    decoration:
                                        BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(0)),
                                    padding: const EdgeInsets.fromLTRB(24.0, 10.0, 24.0, 10.0),
                                    child: const Padding(
                                      padding: EdgeInsets.only(top: 20.0),
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            "Some sections are only accessible to Infinity Members. Please update your membership from the website.",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(fontSize: 18),
                                          ),
                                          SizedBox(height: 20),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 0.0,
                                  top: 0.0,
                                  child: GestureDetector(
                                    onTap: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: Align(
                                        alignment: Alignment.topRight,
                                        child: Image.asset(Images.xButton, width: 25, height: 25)),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    } else {
                      var newAudioList = await viewModel.fetchPlaylistMeditations(int.parse(meditation.playlistId));
                      if (newAudioList.isNotEmpty) {
                        GoRouter.of(context).push(
                          "/audio_section",
                          extra: AudioSectionArgs(newAudioList, "Meditations Library"),
                        );
                      }
                    }
                  },
                  style: const ButtonStyle(
                    padding: WidgetStatePropertyAll(EdgeInsets.zero),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap
                  ),
                  child: Text(
                    "See all",
                    style: TextStyle(
                      color: Colors.white.withOpacity(.8),
                      fontWeight: FontWeight.w500,
                      fontSize: size*0.045,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: size*0.045),
            height: size*0.75,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              itemBuilder: (context, index) {
                if (!viewModel.state.isActive) {
                  //TODO* check builAudioItem responsive
                  return buildAudioItem(meditation.audios[index], context, audioViewModel);
                } else {
                  return buildSubAudioItem(
                      meditation.audios[index], context, audioViewModel, index, meditation.audios, size
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildAudioItem(AudioSectionModel audio, BuildContext context, AudioPlayerViewModel audioViewModel) {
    return GestureDetector(
      onTap: () async {
        if (viewModel.state.isActive) {
          GoRouter.of(context).push("/audio_item", extra: audio);
        } else {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                surfaceTintColor: Colors.transparent,
                backgroundColor: Colors.transparent,
                content: Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(7.0),
                      child: Container(
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(0)),
                        padding: const EdgeInsets.fromLTRB(24.0, 10.0, 24.0, 10.0),
                        child: const Padding(
                          padding: EdgeInsets.only(top: 20.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Please subscribe to Infinity to unlock this meditation",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 18),
                              ),
                              SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0.0,
                      top: 0.0,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Align(
                            alignment: Alignment.topRight, child: Image.asset(Images.xButton, width: 25, height: 25)),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        }
      },
      child: Container(
        width: 150,
        margin: const EdgeInsets.fromLTRB(0, 8, 16, 8),
        child: Column(
          children: [
            AspectRatio(
              aspectRatio: 3 / 4,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(0.0),
                child: CachedNetworkImage(
                  imageUrl: audio.image,
                  progressIndicatorBuilder: (context, url, downloadProgress) => Shimmer(
                      gradient: AppTheme.colors.linearLoading,
                      child: Container(color: Colors.white, width: 300, height: 400)),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                gradient: AppTheme.colors.linearLeaderboard,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(0.0),
                  bottomRight: Radius.circular(0.0),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 40,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 0.0),
                        child: Text(
                          "${audio.title}\n",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  if (viewModel.state.isActive)
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.black26,
                      ),
                      child: const Text(
                        'Unlocked',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 10,
                        ),
                      ),
                    )
                  else
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: const Icon(Icons.lock, size: 15),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildAudioItem2(
      BuildContext context, AudioSectionModel audio, int index, List<AudioSectionModel> allAudioItems, double size) {
    return GestureDetector(
      onTap: () {
        if (!viewModel.state.isActive || viewModel.state.isGuest) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                surfaceTintColor: Colors.transparent,
                backgroundColor: Colors.transparent,
                content: Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(7.0),
                      child: Container(
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(0)),
                        padding: const EdgeInsets.fromLTRB(24.0, 10.0, 24.0, 10.0),
                        child: const Padding(
                          padding: EdgeInsets.only(top: 20.0),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "Some sections are only accessible to Infinity Members. Please update your membership from the website.",
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 18),
                              ),
                              SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 0.0,
                      top: 0.0,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Align(
                            alignment: Alignment.topRight, child: Image.asset(Images.xButton, width: 25, height: 25)),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        } else {
          GoRouter.of(context).push("/audio_item", extra: audio);
        }
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
                if (viewModel.state.isActive)
                  Positioned(
                    bottom: 10,
                    left: 10,
                    right: 10,
                    child: Row(
                      children: [
                        // GestureDetector(
                        //   child: Icon(Icons.thumb_up_rounded,
                        //       size: 20,
                        //       color: audio.isLiked
                        //           ? AppTheme.colors.pinkButton
                        //           : Colors.white),
                        //   onTap: () {
                        //     print("PRESSED");
                        //     viewModel.toggleLiked(audio, index, allAudioItems);
                        //   },
                        // ),
                        // const SizedBox(width: 4),
                        // Text(audio.numOfLikes.toString(),
                        //     style: const TextStyle(color: Colors.white)),
                        const Spacer(),
                        Text(audio.time, style: TextStyle(color: Colors.white,fontSize: size*0.04)),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(height: size*0.02),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: size*0.02),
            child: Text(
              audio.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white,height: 1.2, fontSize: size*0.039),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSubAudioItem(AudioSectionModel audio, BuildContext context, AudioPlayerViewModel audioViewModel,
      int index, List<AudioSectionModel> allAudioItems, double size) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, size*0.02, size*0.045, 0),
      width: size*0.47,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () async {
              GoRouter.of(context).push("/audio_item", extra: audio);
            },
            child: ClipRRect(
              child: AspectRatio(
                aspectRatio: 3 / 4,
                child: Stack(
                  children: [
                    CachedNetworkImage(
                      imageUrl: audio.image,
                      progressIndicatorBuilder: (context, url, downloadProgress) => Shimmer(
                          gradient: AppTheme.colors.linearLoading,
                          child: Container(
                            color: Colors.white,
                            width: 300,
                            height: 400,
                          )),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      bottom: 10,
                      left: 10,
                      right: 10,
                      child: Row(
                        children: [
                          GestureDetector(
                            child: Icon(Icons.thumb_up_rounded,
                                size: size*0.05, color: audio.isLiked ? AppTheme.colors.pinkButton : Colors.white),
                            onTap: () {
                              viewModel.toggleLiked(audio, index, allAudioItems);
                            },
                          ),
                          SizedBox(width: size*0.01),
                          Text(audio.numOfLikes.toString(), style: TextStyle(color: Colors.white,fontSize: size*0.04)),
                          const Spacer(),
                          Text(audio.time, style: TextStyle(color: Colors.white, fontSize: size*0.04)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          SizedBox(height: size*0.025),
          Text(
            audio.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: size*0.038,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
