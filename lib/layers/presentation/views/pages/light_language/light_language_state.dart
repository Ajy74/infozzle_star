import '../../../../domain/models/light_language_audio.dart';

class LightLanguageState {
  List<LightLanguageAudioModel> audioList;
  String currentSearchText;
  bool showErrorMessage;
  bool isLoading;

  LightLanguageState({
    this.audioList = const [],
    this.currentSearchText = "",
    this.showErrorMessage = false,
    this.isLoading = false,
  });

  LightLanguageState.clone(LightLanguageState existingState)
      : this(
            audioList: existingState.audioList,
            currentSearchText: existingState.currentSearchText,
            isLoading: existingState.isLoading,
            showErrorMessage: existingState.showErrorMessage);
}
