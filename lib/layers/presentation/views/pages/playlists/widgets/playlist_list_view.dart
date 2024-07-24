import 'dart:math' as math;

import 'package:art_sweetalert/art_sweetalert.dart';
import 'package:breathpacer/layers/presentation/download_manager/download_view_model.dart';
import 'package:breathpacer/theme/app_theme.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:readmore/readmore.dart';
import 'package:recase/recase.dart';

import '../../../../../domain/models/audio_section_model.dart';
import '../../../../../domain/models/light_language_audio.dart';
import '../../../../../domain/models/playlist_model.dart';
import '../../../../../domain/models/vaults_model.dart';
import '../../../shared_widgets/star_magic/dialog.dart';
import '../../audio_player/audio_player_view_model.dart';
import '../playlists_state.dart';
import '../playlists_view_model.dart';

//ignore: must_be_immutable
class PlaylistListView extends StatelessWidget {
  PlaylistListView({super.key, required this.item, required this.showOptions}) {
    viewModel.checkIfVaultExists(item.title);
    Future.wait([viewModel.getUserPlaylistsLoading(), viewModel.listUpdate(item)])
        .then((_) => viewModel.getPlaylistsContainingAudio());
  }

  final PlaylistItem item;
  final bool showOptions;
  final PlaylistsViewModel viewModel = PlaylistsViewModel();

  @override
  Widget build(BuildContext context) {
    final audioViewModel = context.read<AudioPlayerViewModel>();
    final downloadViewModel = context.read<DownloadViewModel>();
    return Scaffold(
        appBar: AppBar(
          title: Text(ReCase(item.title).titleCase.toString()),
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
        body: BlocBuilder<PlaylistsViewModel, PlaylistsState>(
            bloc: viewModel,
            builder: (_, state) {
              return Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 40, 20, 20),
                    decoration: BoxDecoration(gradient: AppTheme.colors.linearGradient),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (!state.isLoading) buildTopArea(audioViewModel, context, downloadViewModel),
                        const SizedBox(height: 20),
                        Expanded(child: buildList(audioViewModel, downloadViewModel)),
                      ],
                    ),
                  ),
                  if (state.isUserPlaylistsLoading || state.isLoading)
                    Container(
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
                    )
                ],
              );
            }));
  }

  Widget buildTopArea(AudioPlayerViewModel audioViewModel, BuildContext context, DownloadViewModel downloadViewModel) {
    bool isDownloading = downloadViewModel.state.downloadProgressMap.containsKey(viewModel.state.currentPlaylist.title);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          ReCase(viewModel.state.currentPlaylist.title).titleCase.toString(),
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
        ),
        const SizedBox(height: 10),
        ReadMoreText(
          viewModel.state.currentPlaylist.description,
          style: const TextStyle(color: Colors.white, fontSize: 16),
          trimMode: TrimMode.Line,
          trimLines: 3,
          trimCollapsedText: 'More',
          trimExpandedText: ' Less',
          textAlign: TextAlign.center,
          moreStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
          lessStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        Stack(
          children: [
            Center(
              child: IconButton(
                iconSize: 60,
                icon: const Icon(Icons.play_circle_fill),
                color: Colors.white,
                onPressed: () {
                  List<LightLanguageAudioModel> audios =
                      mapAudioToLightLanguageAudio(viewModel.state.currentPlaylist.audios);
                  audioViewModel.populateAudioList(audios);
                  audioViewModel.updateCurrentAudioState();

                  audioViewModel.setAudioPlayer(
                      audioViewModel.state.allAudioList[audioViewModel.state.currentAudioIndex].audioURL, false);
                  GoRouter.of(context).push("/audio_player");
                },
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: TextButton(
                child: isDownloading
                    ? Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: CircularPercentIndicator(
                          radius: 24.0,
                          lineWidth: 5.0,
                          percent:
                              downloadViewModel.state.downloadProgressMap[viewModel.state.currentPlaylist.title]! / 100,
                          center: Text(
                            "${downloadViewModel.state.downloadProgressMap[viewModel.state.currentPlaylist.title]!}%",
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                          progressColor: Colors.white,
                        ),
                      )
                    : Icon(Icons.file_download_outlined,
                        size: 25, color: viewModel.state.isVaultFound ? AppTheme.colors.pinkButton : Colors.white),
                onPressed: () async {
                  if (!isDownloading) {
                    if (viewModel.state.isVaultFound) {
                      Future.microtask(() => ArtSweetAlert.show(
                            context: context,
                            artDialogArgs: ArtDialogArgs(
                              dialogDecoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              denyButtonText: "Cancel",
                              confirmButtonText: "Remove",
                              onConfirm: () {
                                viewModel.deleteVault(viewModel.state.currentPlaylist.title);
                                viewModel.toggleIsFound(false);
                                Navigator.of(context).pop();
                              },
                              type: ArtSweetAlertType.question,
                              title: "Remove Downloads",
                              text: "Are you sure you want to remove from downloads?",
                            ),
                          ));
                    } else {
                      if (!viewModel.state.isVaultFound) {
                        await viewModel.addVault(viewModel.state.currentPlaylist.title);
                      }
                      Future.microtask(() => ArtSweetAlert.show(
                            context: context,
                            artDialogArgs: ArtDialogArgs(
                              dialogDecoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              confirmButtonText: "Dismiss",
                              type: ArtSweetAlertType.info,
                              sizeInfoIcon: 0,
                              title: "Download Started",
                              text:
                                  "\nDownload Started for\n${viewModel.state.currentPlaylist.title}.\nPlease check your notification drawer.",
                            ),
                          ));

                      viewModel.toggleIsFound(true);
                      downloadViewModel
                          .massDownloadFiles(
                              viewModel.state.currentPlaylist.audios, viewModel.state.currentPlaylist.title)
                          .then((value) => viewModel.getVaults());
                    }
                  }
                },
              ),
            ),
            if (showOptions)
              Positioned(
                left: 0,
                child: PopupMenuButton(
                  surfaceTintColor: Colors.white,
                  color: Colors.white,
                  icon: const Icon(Icons.more_vert, color: Colors.white),
                  onSelected: (value) async {
                    final navigator = Navigator.of(context);
                    if (value == 'delete') {
                      await viewModel.deletePlaylist(viewModel.state.currentPlaylist.id);
                      navigator.pop();
                    } else if (value == 'rename') {
                      showDialog(
                        context: context,
                        builder: (context) => CustomDialog(
                          title: 'Rename Playlist',
                          hint: "New Name",
                          onTap: (newName) async {
                            await viewModel.renamePlaylist(viewModel.state.currentPlaylist.id, newName);
                            navigator.pop();
                          },
                        ),
                      );
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'delete',
                      child: Text('Delete Playlist'),
                    ),
                    const PopupMenuItem(
                      value: 'rename',
                      child: Text("Rename Playlist"),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget buildList(AudioPlayerViewModel audioViewModel, DownloadViewModel downloadViewModel) {
    return ListView.builder(
      itemCount: viewModel.state.currentPlaylist.audios.length,
      itemBuilder: (context, index) {
        final audio = viewModel.state.currentPlaylist.audios[index];
        viewModel.setCurrentAudio(viewModel.state.currentPlaylist.audios[index]);
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 0.0),
              leading: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                child: AspectRatio(
                  aspectRatio: 1 / 1,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      imageUrl: audio.image,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          const Padding(padding: EdgeInsets.all(10), child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                    ),
                  ),
                ),
              ),
              title: Text(
                audio.title,
                style: const TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                audio.time,
                style: const TextStyle(color: Colors.white70),
              ),
              trailing: PopupMenuButton(
                surfaceTintColor: Colors.white,
                color: Colors.white,
                icon: const Icon(Icons.more_vert, color: Colors.white),
                onSelected: (value) async {
                  if (value == 'play') {
                    List<LightLanguageAudioModel> audios =
                        mapSingleAudioToLightLanguageAudio(viewModel.state.currentPlaylist.audios[index]);
                    audioViewModel.populateAudioList(audios);
                    audioViewModel.updateCurrentAudioState();
                    audioViewModel.setAudioPlayer(
                        audioViewModel.state.allAudioList[audioViewModel.state.currentAudioIndex].audioURL, false);
                    GoRouter.of(context).push("/audio_player");
                  } else if (value == 'playlist') {
                    showPlaylistPopup(context, viewModel, audio);
                  } else if (value == 'vault') {
                    showVaultsPopup(context, viewModel.state.vaultNames, viewModel, index,
                        viewModel.state.currentPlaylist, downloadViewModel);
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'play',
                    child: Text('Play'),
                  ),
                  const PopupMenuItem(
                    value: 'playlist',
                    child: Text('Save to playlist'),
                  ),
                  const PopupMenuItem(value: 'vault', child: Text("Add to Vault")),
                ],
              ),
              onTap: () {},
            ),
          ),
        );
      },
    );
  }
}

void showVaultsPopup(BuildContext context, List<VaultsModel> vaults, PlaylistsViewModel viewModel, int index,
    PlaylistItem item, DownloadViewModel downloadViewModel) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(5),
        ),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: Transform.rotate(
                      angle: math.pi / 4,
                      child: IconButton(
                        icon: const Icon(
                          Icons.add_circle_rounded,
                          color: Colors.black,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ),
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Text(
                        "Select Your Vault",
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
                  return Container(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.5,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: vaults.map((vault) {
                          bool isDownloaded = isAudioInVaults(item.audios[index].title, [vault]);
                          return Column(
                            children: [
                              ListTile(
                                title: Text(vault.title),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      "${vault.audios.length} items",
                                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                                    ),
                                    const SizedBox(width: 5),
                                    if (isDownloaded)
                                      const Icon(
                                        Icons.cloud_done,
                                        color: Colors.blue,
                                      ),
                                  ],
                                ),
                                onTap: () {
                                  downloadViewModel.downloadFile(item.audios[index].audioURL, item.audios[index].title,
                                      item.audios[index].title, vault.title, mapVaultAudio(item.audios[index]), () {
                                    viewModel.getVaults();
                                  });
                                  Navigator.of(context).pop();
                                },
                              ),
                              const Divider(),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      );
    },
  );
}

bool isAudioInVaults(String audioTitle, List<VaultsModel> vaults) {
  for (var vault in vaults) {
    for (var audio in vault.audios) {
      if (audio.title == audioTitle) {
        return true;
      }
    }
  }
  return false;
}

void showPlaylistPopup(BuildContext context, PlaylistsViewModel viewModel, AudioSectionModel audio) {
  bool isLoading = false;
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
          return Stack(
            children: [
              Center(
                child: Material(
                  borderRadius: BorderRadius.circular(5),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Stack(
                          children: [
                            Align(
                              alignment: Alignment.topRight,
                              child: Transform.rotate(
                                angle: math.pi / 4,
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.add_circle_rounded,
                                    color: Colors.black,
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ),
                            ),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 16.0),
                                child: Text(
                                  "Select Your Playlist",
                                  style: TextStyle(
                                    color: Colors.grey[700],
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Container(
                          constraints: BoxConstraints(
                            maxHeight: MediaQuery.of(context).size.height * 0.5,
                          ),
                          child: SingleChildScrollView(
                            child: Column(
                              children: viewModel.state.playlistsNames.map((playlist) {
                                print(viewModel.state.savedInPlaylists[audio.id]);
                                bool isSelected =
                                    viewModel.state.savedInPlaylists[audio.id]?.contains(playlist.title) ?? false;

                                return Column(
                                  children: [
                                    ListTile(
                                      title: Text(playlist.title),
                                      trailing: Checkbox(
                                        value: isSelected,
                                        onChanged: (bool? value) async {
                                          setState(() {
                                            isLoading = true;
                                          });
                                          if (value == true) {
                                            await viewModel.addToPlaylist(audio.id, playlist.id, audio.title);
                                            setState(() {
                                              viewModel.toggleIsAddedToPlaylist(true);
                                            });
                                          } else {
                                            await viewModel.removeFromPlaylist(audio.id, [playlist.id], audio.title);
                                            setState(() {
                                              if (viewModel.state.savedInPlaylists.isEmpty) {
                                                viewModel.toggleIsAddedToPlaylist(false);
                                              }
                                            });
                                          }
                                          setState(() {
                                            isLoading = false;
                                          });
                                        },
                                      ),
                                      onTap: () async {
                                        setState(() {
                                          isLoading = true;
                                        });
                                        if (isSelected) {
                                          await viewModel.removeFromPlaylist(audio.id, [playlist.id], audio.title);
                                          setState(() {
                                            if (viewModel.state.savedInPlaylists.isEmpty) {
                                              viewModel.toggleIsAddedToPlaylist(false);
                                            }
                                          });
                                        } else {
                                          await viewModel.addToPlaylist(audio.id, playlist.id, audio.title);
                                          setState(() {
                                            viewModel.toggleIsAddedToPlaylist(true);
                                          });
                                        }
                                        setState(() {
                                          isLoading = false;
                                        });
                                      },
                                    ),
                                    const Divider(),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              if (isLoading)
                Container(
                  color: Colors.transparent,
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(10)),
                          color: Colors.grey[300],
                        ),
                        child: const Center(
                          child: CircularProgressIndicator(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      );
    },
  );
}

List<LightLanguageAudioModel> mapAudioToLightLanguageAudio(List<AudioSectionModel> allAudios) {
  List<LightLanguageAudioModel> list = [];
  for (var audio in allAudios) {
    list.add(LightLanguageAudioModel(
        id: audio.id,
        title: audio.title,
        image: audio.image,
        audioURL: audio.audioURL,
        originalURL: audio.originalURL,
        isDownloaded: audio.isDownloaded,
        isAddedToPlaylist: false,
        savedInPlaylists: [],
        savedInVaults: [],
        downloadedAt: ""));
  }
  return list;
}

List<LightLanguageAudioModel> mapSingleAudioToLightLanguageAudio(AudioSectionModel audio) {
  List<LightLanguageAudioModel> list = [];
  list.add(LightLanguageAudioModel(
      id: audio.id,
      title: audio.title,
      image: audio.image,
      audioURL: audio.audioURL,
      originalURL: audio.originalURL,
      isDownloaded: audio.isDownloaded,
      isAddedToPlaylist: false,
      savedInPlaylists: [],
      savedInVaults: [],
      downloadedAt: ""));

  return list;
}

LightLanguageAudioModel mapVaultAudio(AudioSectionModel audio) {
  var vaultAudio = (LightLanguageAudioModel(
      id: audio.id,
      title: audio.title,
      image: audio.image,
      audioURL: audio.audioURL,
      originalURL: audio.originalURL,
      isDownloaded: audio.isDownloaded,
      isAddedToPlaylist: false,
      savedInPlaylists: [],
      savedInVaults: [],
      downloadedAt: ""));

  return vaultAudio;
}

class PlaylistListViewArgs {
  // Used to get parameters through the extra in the router
  final PlaylistItem playlist;
  final bool showOptions;

  PlaylistListViewArgs(this.playlist, this.showOptions);
}
