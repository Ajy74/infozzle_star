import 'dart:math' as math;

import 'package:breathpacer/layers/domain/models/vaults_model.dart';
import 'package:breathpacer/layers/presentation/views/shared_widgets/star_magic/audio_item/audio_item_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

import '../../../../../../../theme/app_theme.dart';
import '../../../../../../core/globals.dart';
import '../../../../../../domain/models/light_language_audio.dart';
import '../../../../../download_manager/download_helper.dart';
import '../../../../../download_manager/download_view_model.dart';

class VaultsPopupSelectorItem extends HookWidget {
  final String title;
  final List<VaultsModel> model;
  final AudioItemViewModel viewModel;
  final Function(List<String>) onTap;
  final String url;
  final String filename;
  final LightLanguageAudioModel audio;

  const VaultsPopupSelectorItem({
    super.key,
    required this.title,
    required this.model,
    required this.viewModel,
    required this.onTap,
    required this.filename,
    required this.url,
    required this.audio,
  });

  void _showPopup(BuildContext context, List<VaultsModel> vaults, AudioItemViewModel viewModel,
      DownloadViewModel downloadViewModel) {
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
                StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                    return Container(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height * 0.5,
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          children: vaults.map((vault) {
                            bool isSelected = viewModel.state.savedInPlaylists.contains(vault.title);
                            bool isDownloaded = isAudioInVaults(audio.title, [vault]);
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
                                    if (!isSelected) {
                                      downloadViewModel.downloadFile(
                                          url, filename, audio.title, vault.title, audio, null);
                                      Navigator.of(context).pop();
                                    }
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

  @override
  Widget build(BuildContext context) {
    final downloadViewModel = context.read<DownloadViewModel>();
    bool isDownloading = downloadViewModel.state.downloadProgressMap.containsKey(url);

    useEffect(() {
      DownloadHelper.getDownloadedPath(audio.id).then((value) => viewModel.updateIsDownloaded(value != null));
      return null;
    });

    return TextButton(
      onPressed: () async {
        if (!isDownloading) {
          await viewModel.getVaults();
          _showPopup(context, viewModel.state.vaultNames, viewModel, downloadViewModel);
        }
      },
      style: TextButton.styleFrom(backgroundColor: Colors.transparent, padding: EdgeInsets.zero),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isDownloading)
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: CircularPercentIndicator(
                radius: 24.0,
                lineWidth: 5.0,
                percent: downloadViewModel.state.downloadProgressMap[url]! / 100,
                center: Text(
                  "${downloadViewModel.state.downloadProgressMap[url]!}%",
                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                progressColor: Colors.white,
              ),
            ),
          if (!isDownloading)
            Icon(
              viewModel.state.isDownloaded ? Icons.cloud_done_rounded : Icons.cloud_download_rounded,
              size: 20,
              color: viewModel.state.isDownloaded ? AppTheme.colors.downloadButton : Colors.white,
            ),
          const SizedBox(width: 10),
          Text(
            viewModel.state.isDownloaded ? "Enabled\noffline" : "Enable\noffline",
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
