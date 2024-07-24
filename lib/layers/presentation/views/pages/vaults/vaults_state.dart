import 'package:breathpacer/layers/domain/models/vaults_model.dart';

class VaultsState {
  List<VaultsModel> vaults;

  VaultsState({
    this.vaults = const [],
  });

  VaultsState.clone(VaultsState existingState)
      : this(
          vaults: existingState.vaults,
        );
}
