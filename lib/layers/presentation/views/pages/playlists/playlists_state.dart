import '../../../../domain/models/audio_section_model.dart';
import '../../../../domain/models/playlist_model.dart';
import '../../../../domain/models/vaults_model.dart';

class PlaylistsState {
  AudioSectionModel audio;
  List<PlaylistModel> playlists;
  List<PlaylistItem> playlistsNames;
  PlaylistItem currentPlaylist;
  bool isDownloaded;
  bool isAddedToPlaylist;
  bool showErrorMessage;
  String selectedVault;
  String errorTitle;
  String errorMessage;
  bool isLoading;
  bool isPlaylistsLoading;
  bool isUserPlaylistsLoading;
  bool isVaultFound;
  List<VaultsModel> vaultNames;
  Map<int, Set<String>> savedInPlaylists;
  List<String> savedInVaults;

  PlaylistsState({
    this.playlists = const [],
    this.currentPlaylist = const PlaylistItem(audios: [], image: "", title: "", id: 0, description: ''),
    this.playlistsNames = const [],
    this.isDownloaded = false,
    this.isAddedToPlaylist = false,
    this.showErrorMessage = false,
    this.isUserPlaylistsLoading = false,
    this.isLoading = false,
    this.isPlaylistsLoading = false,
    this.isVaultFound = false,
    this.errorMessage = '',
    this.errorTitle = '',
    this.selectedVault = '',
    this.vaultNames = const [],
    this.savedInPlaylists = const {},
    this.savedInVaults = const [],
    AudioSectionModel? audio,
  }) : audio = audio ??
            AudioSectionModel(
                id: 0,
                title: "",
                image: "",
                time: "",
                unlocked: false,
                description: "",
                audioURL: "",
                originalURL: "",
                numOfLikes: 0,
                isLiked: false,
                isDownloaded: false,
                isAddedToPlaylist: false,
                savedInPlaylists: [],
                savedInVaults: []);

  PlaylistsState.clone(PlaylistsState existingState)
      : this(
            playlists: existingState.playlists,
            isLoading: existingState.isLoading,
            currentPlaylist: existingState.currentPlaylist,
            isDownloaded: existingState.isDownloaded,
            selectedVault: existingState.selectedVault,
            isAddedToPlaylist: existingState.isAddedToPlaylist,
            showErrorMessage: existingState.showErrorMessage,
            isPlaylistsLoading: existingState.isPlaylistsLoading,
            errorMessage: existingState.errorMessage,
            isUserPlaylistsLoading: existingState.isUserPlaylistsLoading,
            errorTitle: existingState.errorTitle,
            isVaultFound: existingState.isVaultFound,
            playlistsNames: existingState.playlistsNames,
            vaultNames: existingState.vaultNames,
            savedInPlaylists: existingState.savedInPlaylists,
            savedInVaults: existingState.savedInVaults,
            audio: existingState.audio);
}
