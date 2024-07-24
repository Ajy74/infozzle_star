import 'dart:math' as math;

import 'package:breathpacer/layers/domain/models/light_language_audio.dart';
import 'package:breathpacer/layers/presentation/views/pages/vault_details/vault_details_state.dart';
import 'package:breathpacer/layers/presentation/views/pages/vault_details/vault_details_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../../theme/app_theme.dart';
import '../../../../domain/models/vaults_model.dart';
import '../audio_player/audio_player_view_model.dart';

class VaultDetailsView extends StatelessWidget {
  VaultDetailsView({super.key, required this.vault}) {
    viewModel.populateVaultList(vault);
    viewModel.fetchDownloadDates();
  }

  final VaultDetailsViewModel viewModel = VaultDetailsViewModel();
  final VaultsModel vault;

  @override
  Widget build(BuildContext context) {
    final audioViewModel = context.read<AudioPlayerViewModel>();
    return Container(
      decoration: BoxDecoration(gradient: AppTheme.colors.linearGradient),
      child: SafeArea(
        top: false,
        bottom: false,
        child: Scaffold(
          appBar: AppBar(
            title: Text(viewModel.state.vault.title),
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
          body: BlocBuilder<VaultDetailsViewModel, VaultDetailsState>(
            bloc: viewModel,
            builder: (_, state) {
              return SafeArea(
                top: true,
                bottom: true,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        SizedBox(
                          height: constraints.maxHeight - 100,
                          child: ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: state.vault.audios.length,
                            itemBuilder: (context, index) {
                              LightLanguageAudioModel audio = state.vault.audios[index];
                              String downloadDate = state.downloadDates[audio.id] ?? '';
                              return buildAudioItem(context, audio, audioViewModel, downloadDate, index);
                            },
                          ),
                        ),
                        const Spacer(),
                        buildUtilizationSection(),
                      ],
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget buildAudioItem(
    BuildContext context,
    LightLanguageAudioModel audio,
    AudioPlayerViewModel audioViewModel,
    String downloadDate,
    int index,
  ) {
    return GestureDetector(
      onTap: () {
        List<LightLanguageAudioModel> audios = [audio];
        audioViewModel.populateAudioList(audios);
        audioViewModel.updateCurrentAudioState();

        audioViewModel.setAudioPlayer(
          audioViewModel.state.allAudioList[audioViewModel.state.currentAudioIndex].audioURL,
          false,
        );
        GoRouter.of(context).push("/audio_player");
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.fromLTRB(16, 0, 0, 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    audio.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                Transform.rotate(
                  angle: math.pi / 4,
                  child: IconButton(
                    icon: const Icon(
                      Icons.add_circle_rounded,
                      color: Colors.black,
                    ),
                    onPressed: () {
                      viewModel.deleteAudioFromVault(audio.id, index);
                    },
                  ),
                ),
              ],
            ),
            Text(
              'Downloaded At',
              style: TextStyle(
                color: Colors.grey[800],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              downloadDate,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildUtilizationSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            'Vault Utilisation: ${viewModel.state.vault.audios.length}',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
