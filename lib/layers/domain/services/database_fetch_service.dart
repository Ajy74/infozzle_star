import 'package:breathpacer/layers/domain/models/blog_model.dart';
import 'package:breathpacer/layers/domain/models/meditation_model.dart';
import 'package:breathpacer/layers/domain/models/playlist_model.dart';
import 'package:breathpacer/layers/domain/models/resources_model.dart';
import 'package:breathpacer/layers/domain/models/streak_model.dart';

import '../models/audio_section_model.dart';
import '../models/leaderboard_model.dart';
import '../models/light_language_audio.dart';
import '../models/video_model.dart';

abstract class DatabaseFetchService {
  Future<List<LightLanguageAudioModel>> fetchLightLanguageAudios(String token);
  Future<List<MeditationModel>> fetchMeditations();
  Future<List<MeditationModel>> fetchAllMeditations(bool ignoreCache);
  Future<AudioSectionModel> getSingleAudioInfo(String libraryId, String bearerToken);
  Future<List<VideoModel>> fetchYogaVideos(String token);
  Future<List<BlogModel>> fetchBlogs(String blogType);
  Future<StreakModel> getStreak(String token);
  Future<List<LeaderboardModel>> getLeaderboards(String token);
  Future<List<PlaylistItem>> getUserPlaylists(String token);
  Future<List<PlaylistItem>> getUserPlaylistsSimple(String token);
  Future<List<PlaylistModel>> getCuratedPlaylists(String token);
  Future<List<AudioSectionModel>> updateAudioList(String token, List<AudioSectionModel> oldAudios, int playlistId);
  Future<String> getDashboard(String token);
  Future<List<ResourcesModel>> getResources(String token, String type);
  Future<List<AudioSectionModel>> getPlaylistMeditations(String token, int playlistId);

  Future<void> addLike(int libraryID, String token);
  Future<void> removeLike(int libraryID, String token);
  Future<void> createPlaylist(String name, String token);
  Future<void> deletePlaylist(int id, String token);
  Future<void> editPlaylistName(int id, String newName, String token);
  Future<void> addAudioToPlaylist(int audioID, int playlistID, String token);
  Future<void> removeAudiosFromPlaylists(int audioID, List<int> playlistID, String token);
  Future<String> increaseStreak(String timezone, String token);
}
