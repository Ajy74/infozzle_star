import 'package:breathpacer/layers/core/globals.dart';
import 'package:breathpacer/layers/domain/models/vaults_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'vaults_state.dart';

class VaultsViewModel extends Cubit<VaultsState> {
  VaultsViewModel() : super(VaultsState()) {
    populateVaultsList();
  }

  Future<void> populateVaultsList() async {
    var list = await globalLoadVaults();
    state.vaults = list ?? [];
    emit(VaultsState.clone(state));
  }

  Future<void> renameVault(String oldName, String newName) async {
    await globalRenameVault(oldName, newName);
    await populateVaultsList();
    emit(VaultsState.clone(state));
  }

  Future<void> addVault(String title) async {
    await globalAddVault(VaultsModel(title: title, audios: []));
    await populateVaultsList();
    emit(VaultsState.clone(state));
  }

  Future<void> deleteVault(String vaultName) async {
    var vault = state.vaults.firstWhere((vault) => vault.title == vaultName);

    await globalRemoveVault(vaultName, vault.audios);
    await populateVaultsList();
    emit(VaultsState.clone(state));
  }

  void reset() {
    emit(VaultsState());
  }
}
