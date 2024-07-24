import '../../../../domain/models/audio_section_model.dart';
import '../../../../domain/models/meditation_model.dart';

class MeditationState {
  List<MeditationModel> meditations;
  List<AudioSectionModel> filteredAudios;
  String currentSearchText;
  bool showErrorMessage;
  String errorTitle;
  String errorMessage;
  bool isLoading;
  bool isActive;
  bool isGuest;

  MeditationState({
    this.meditations = const [],
    this.filteredAudios = const [],
    this.currentSearchText = '',
    this.showErrorMessage = false,
    this.errorMessage = '',
    this.errorTitle = '',
    this.isLoading = false,
    this.isActive = true,
    this.isGuest = false,
  });

  MeditationState.clone(MeditationState existingState)
      : this(
            meditations: existingState.meditations,
            filteredAudios: existingState.filteredAudios,
            currentSearchText: existingState.currentSearchText,
            showErrorMessage: existingState.showErrorMessage,
            errorTitle: existingState.errorTitle,
            errorMessage: existingState.errorMessage,
            isActive: existingState.isActive,
            isGuest: existingState.isGuest,
            isLoading: existingState.isLoading);
}
