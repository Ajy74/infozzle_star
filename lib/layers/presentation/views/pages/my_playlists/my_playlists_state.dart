import 'package:breathpacer/layers/domain/models/playlist_model.dart';

class MyPlaylistsState {
  List<PlaylistItem> playlists;
  bool showErrorMessage;
  String errorTitle;
  String errorMessage;
  bool isLoading;

  MyPlaylistsState({
    this.playlists = const [],
    this.showErrorMessage = false,
    this.isLoading = false,
    this.errorTitle = "",
    this.errorMessage = "",
  });

  MyPlaylistsState.clone(MyPlaylistsState existingState)
      : this(
          playlists: existingState.playlists,
          showErrorMessage: existingState.showErrorMessage,
          isLoading: existingState.isLoading,
          errorMessage: existingState.errorMessage,
          errorTitle: existingState.errorTitle,
        );
}
