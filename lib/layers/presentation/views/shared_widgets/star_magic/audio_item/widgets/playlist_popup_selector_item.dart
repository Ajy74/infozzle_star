import 'dart:math' as math;

import 'package:breathpacer/layers/domain/models/playlist_model.dart';
import 'package:breathpacer/layers/presentation/views/shared_widgets/star_magic/audio_item/audio_item_view_model.dart';
import 'package:flutter/material.dart';

import '../../../../../../../theme/app_theme.dart';

class PlaylistsPopupSelectorItem extends StatelessWidget {
  final String title;
  final List<PlaylistItem> model;
  final Function(List<String>) onTap;
  final Icon icon;
  final AudioItemViewModel viewModel;

  const PlaylistsPopupSelectorItem(
      {super.key,
      required this.title,
      required this.model,
      required this.onTap,
      required this.icon,
      required this.viewModel});

  void _showPopup(BuildContext context, List<PlaylistItem> playlists, AudioItemViewModel viewModel) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Center(
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
                                title,
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
                            children: playlists.map((playlist) {
                              bool isSelected = viewModel.state.savedInPlaylists.contains(playlist.title);
                              return Column(
                                children: [
                                  ListTile(
                                    title: Text(playlist.title),
                                    trailing: Checkbox(
                                      value: isSelected,
                                      onChanged: (bool? value) async {
                                        if (value == true) {
                                          await viewModel.addToPlaylist(
                                              viewModel.state.audio.id, playlist.id, viewModel.state.audio.title);
                                          setState(() {
                                            viewModel.toggleIsAddedToPlaylist(true);
                                          });
                                        } else {
                                          await viewModel.removeFromPlaylist(
                                              viewModel.state.audio.id, [playlist.id], viewModel.state.audio.title);
                                          setState(() {
                                            if (viewModel.state.savedInPlaylists.isEmpty) {
                                              viewModel.toggleIsAddedToPlaylist(false);
                                            }
                                          });
                                        }
                                      },
                                    ),
                                    onTap: () async {
                                      if (isSelected) {
                                        await viewModel.removeFromPlaylist(
                                            viewModel.state.audio.id, [playlist.id], viewModel.state.audio.title);
                                        setState(() {
                                          if (viewModel.state.savedInPlaylists.isEmpty) {
                                            viewModel.toggleIsAddedToPlaylist(false);
                                          }
                                        });
                                      } else {
                                        await viewModel.addToPlaylist(
                                            viewModel.state.audio.id, playlist.id, viewModel.state.audio.title);
                                        setState(() {
                                          viewModel.toggleIsAddedToPlaylist(true);
                                        });
                                      }
                                      await viewModel.getPlaylists();
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
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () async {
        _showPopup(context, viewModel.state.playlistsNames, viewModel);
      },
      style: TextButton.styleFrom(backgroundColor: Colors.transparent, padding: EdgeInsets.zero),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.favorite,
              size: 20, color: viewModel.state.isAddedToPlaylist ? AppTheme.colors.pinkButton : Colors.white),
          const SizedBox(width: 10),
          Text(
            viewModel.state.isAddedToPlaylist ? "Added to\nplaylist" : "Add to\nplaylist",
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }
}