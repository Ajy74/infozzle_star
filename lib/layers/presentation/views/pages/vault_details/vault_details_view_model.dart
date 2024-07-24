import 'dart:io';

import 'package:breathpacer/layers/core/globals.dart';
import 'package:breathpacer/layers/domain/models/vaults_model.dart';
import 'package:breathpacer/layers/presentation/views/pages/vault_details/vault_details_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';

class VaultDetailsViewModel extends Cubit<VaultDetailsState> {
  VaultDetailsViewModel() : super(VaultDetailsState());

  void populateVaultList(VaultsModel model) {
    state.vault = model;
    emit(VaultDetailsState.clone(state));
  }

  Future deleteAudioFromVault(int audioID, int audioIndex) async {
    await globalDeleteAudioFromVault(state.vault.title, audioID);
    state.vault.audios.removeAt(audioIndex);
    emit(VaultDetailsState.clone(state));
  }

  Future<void> fetchDownloadDates() async {
    for (var audio in state.vault.audios) {
      await getDownloadDate(audio.id.toString(), audio.id);
    }
  }

  Future<bool> getDownloadDate(String filename, int audioId) async {
    if (!filename.endsWith('.mp3')) {
      filename += '_${state.vault.title}.mp3';
    }

    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$filename';

    try {
      File file = File(filePath);
      DateTime lastModified = await file.lastModified();

      String period = (lastModified.hour < 12) ? 'AM' : 'PM';
      int hourOfDay = (lastModified.hour == 0 || lastModified.hour == 12) ? 12 : lastModified.hour % 12;
      String formattedDate =
          '${lastModified.day}/${lastModified.month}/${lastModified.year} $hourOfDay:${lastModified.minute} $period';

      Map<int, String> updatedDownloadDates = Map.from(state.downloadDates);
      updatedDownloadDates[audioId] = formattedDate;

      emit(VaultDetailsState(
        vault: state.vault,
        downloadDates: updatedDownloadDates,
      ));

      return true;
    } catch (e) {
      print('Error retrieving download date: $e');
      return false;
    }
  }

  void reset() {
    emit(VaultDetailsState());
  }
}
