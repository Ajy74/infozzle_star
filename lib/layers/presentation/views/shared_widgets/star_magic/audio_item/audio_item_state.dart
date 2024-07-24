import '../../../../../domain/models/audio_section_model.dart';
import '../../../../../domain/models/playlist_model.dart';
import '../../../../../domain/models/vaults_model.dart';

class AudioItemState {
  AudioSectionModel audio;
  bool isDownloaded;
  bool isAddedToPlaylist;
  bool showErrorMessage;
  List<PlaylistItem> playlistsNames;
  List<VaultsModel> vaultNames;
  Set<String> savedInPlaylists;
  String savedInVaults;
  bool isLiked;
  bool isLoading;
  bool isLoadingUserPlaylists;

  AudioItemState({
    this.isDownloaded = false,
    this.isAddedToPlaylist = false,
    this.showErrorMessage = false,
    this.playlistsNames = const [],
    this.vaultNames = const [],
    this.savedInPlaylists = const {},
    this.savedInVaults = "",
    this.isLiked = false,
    this.isLoadingUserPlaylists = false,
    this.isLoading = false,
    AudioSectionModel? audio,
  }) : audio = audio ??
            AudioSectionModel(
                id: 0,
                title: "",
                image: "",
                time: "",
                description: "",
                unlocked: false,
                audioURL: "",
                originalURL: "",
                numOfLikes: 0,
                isLiked: false,
                isDownloaded: false,
                isAddedToPlaylist: false,
                savedInPlaylists: [],
                savedInVaults: []);

  AudioItemState.clone(AudioItemState existingState)
      : this(
            isDownloaded: existingState.isDownloaded,
            isAddedToPlaylist: existingState.isAddedToPlaylist,
            savedInPlaylists: existingState.savedInPlaylists,
            showErrorMessage: existingState.showErrorMessage,
            playlistsNames: existingState.playlistsNames,
            isLoadingUserPlaylists: existingState.isLoadingUserPlaylists,
            vaultNames: existingState.vaultNames,
            isLiked: existingState.isLiked,
            isLoading: existingState.isLoading,
            savedInVaults: existingState.savedInVaults,
            audio: existingState.audio);
}
