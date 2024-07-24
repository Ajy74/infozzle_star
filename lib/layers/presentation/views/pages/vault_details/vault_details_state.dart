import 'package:breathpacer/layers/domain/models/vaults_model.dart';

class VaultDetailsState {
  VaultsModel vault;
  Map<int, String> downloadDates;

  VaultDetailsState({
    this.vault = const VaultsModel(title: '', audios: []),
    Map<int, String>? downloadDates,
  }) : downloadDates = downloadDates ?? {};

  VaultDetailsState.clone(VaultDetailsState existingState)
      : this(vault: existingState.vault, downloadDates: Map.from(existingState.downloadDates));
}
