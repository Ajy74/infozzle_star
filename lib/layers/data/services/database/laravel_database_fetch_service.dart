import 'dart:convert';

import 'package:breathpacer/layers/domain/models/blog_model.dart';
import 'package:breathpacer/layers/domain/models/leaderboard_model.dart';
import 'package:breathpacer/layers/domain/models/meditation_model.dart';
import 'package:breathpacer/layers/domain/models/playlist_model.dart';
import 'package:breathpacer/layers/domain/models/resources_model.dart';
import 'package:breathpacer/layers/domain/models/streak_model.dart';
import 'package:breathpacer/layers/domain/models/video_model.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart' as http;

import '../../../core/globals.dart';
import '../../../domain/models/audio_section_model.dart';
import '../../../domain/models/light_language_audio.dart';
import '../../../domain/services/database_fetch_service.dart';

class LaravelDatabaseFetchService implements DatabaseFetchService {
  final String liveApiUrl = "https://api.starmagichealing.org/api/";
  final cacheManager = DefaultCacheManager();

  @override
  Future<List<LightLanguageAudioModel>> fetchLightLanguageAudios(String token) async {
    final url = '${liveApiUrl}get-blogs?blog_type=light_language';
    final cacheFile = await cacheManager.getFileFromCache(url);

    if (cacheFile != null && await cacheFile.file.exists()) {
      final fileContent = await cacheFile.file.readAsString();
      return LightLanguageAudioModel.fromJsonList(json.decode(fileContent));
    }

    final response = await http.get(
      Uri.parse(url),
    );

    if (response.statusCode == 200) {
      await cacheManager.putFile(
        url,
        response.bodyBytes,
        fileExtension: 'json',
        maxAge: const Duration(hours: 12),
      );
      return LightLanguageAudioModel.fromJsonList(json.decode(response.body));
    } else {
      throw Exception('Failed to fetch data');
    }
  }

  @override
  Future<List<MeditationModel>> fetchMeditations() async {
    final url = '${liveApiUrl}get-curated-playlists';
    final token = await globalGetToken();

    try {
      var response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (token != null && token.isNotEmpty) {
        response = await http.get(
          Uri.parse(url),
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        );
      }

      if (response.statusCode == 200) {
        await cacheManager.putFile(
          url,
          response.bodyBytes,
          fileExtension: 'json',
          maxAge: const Duration(hours: 12),
        );
        final jsonResponse = jsonDecode(response.body);
        List<MeditationModel> playlists = MeditationModel.fromJsonList(jsonResponse['data']);
        return playlists;
      } else {
        throw Exception('Failed to load playlists');
      }
    } catch (e) {
      throw Exception('Failed to fetch playlists: $e');
    }
  }

  @override
  Future<List<MeditationModel>> fetchAllMeditations(bool ignoreCache) async {
    final url = '${liveApiUrl}get-curated-all-audios';
    final token = await globalGetToken();

    try {
      if (!ignoreCache) {
        final cacheFile = await cacheManager.getFileFromCache(url);
        if (cacheFile != null && await cacheFile.file.exists()) {
          final fileContent = await cacheFile.file.readAsString();
          List<MeditationModel> cachedData = MeditationModel.fromJsonList(jsonDecode(fileContent)['data']);
          return cachedData;
        }
      }

      var headers = {
        'Content-Type': 'application/json',
      };

      if (token != null && token.isNotEmpty) {
        headers['Authorization'] = 'Bearer $token';
      }

      var response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      if (response.statusCode == 200) {
        await cacheManager.putFile(
          url,
          response.bodyBytes,
          fileExtension: 'json',
          maxAge: const Duration(hours: 12),
        );
        final jsonResponse = jsonDecode(response.body);
        List<MeditationModel> playlists = MeditationModel.fromJsonList(jsonResponse['data']);
        return playlists;
      } else {
        throw Exception('Failed to load playlists');
      }
    } catch (e) {
      throw Exception('Failed to fetch playlists: $e');
    }
  }

  @override
  Future<AudioSectionModel> getSingleAudioInfo(String libraryId, String bearerToken) async {
    final url = '${liveApiUrl}get-single-audio?library_id=$libraryId';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $bearerToken',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        await cacheManager.putFile(
          url,
          response.bodyBytes,
          fileExtension: 'json',
          maxAge: const Duration(hours: 12),
        );
        final jsonResponse = jsonDecode(response.body);
        final audioInfo = jsonResponse['data'];
        print('Data fetched from network');
        return AudioSectionModel.fromJson(audioInfo);
      } else {
        throw Exception('Failed to load audio info');
      }
    } catch (e) {
      throw Exception('Failed to fetch audio info: $e');
    }
  }

  @override
  Future<List<VideoModel>> fetchYogaVideos(String token) async {
    final url = '${liveApiUrl}get-yoga-videos';
    final cacheFile = await cacheManager.getFileFromCache(url);

    if (cacheFile != null && await cacheFile.file.exists()) {
      final fileContent = await cacheFile.file.readAsString();
      return VideoModel.fromJsonList(json.decode(fileContent));
    } else {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        await cacheManager.putFile(
          url,
          response.bodyBytes,
          fileExtension: 'json',
          maxAge: const Duration(hours: 12),
        );
        return VideoModel.fromJsonList(json.decode(response.body));
      } else {
        throw Exception('Failed to fetch data');
      }
    }
  }

  @override
  Future<List<BlogModel>> fetchBlogs(String blogType) async {
    final url = '${liveApiUrl}get-blogs?blog_type=$blogType';
    final cacheFile = await cacheManager.getFileFromCache(url);

    if (cacheFile != null && await cacheFile.file.exists()) {
      final fileContent = await cacheFile.file.readAsString();
      final jsonData = json.decode(fileContent);
      final List<dynamic> blogListJson = jsonData['data'];
      return BlogModel.fromJsonList(blogListJson);
    } else {
      final response = await http.get(
        Uri.parse(url),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<dynamic> blogListJson = jsonData['data'];

        await cacheManager.putFile(
          url,
          response.bodyBytes,
          fileExtension: 'json',
          maxAge: const Duration(hours: 12),
        );

        return BlogModel.fromJsonList(blogListJson);
      } else {
        throw Exception('Failed to fetch blogs');
      }
    }
  }

  @override
  Future<List<LeaderboardModel>> getLeaderboards(String token) async {
    final url = '${liveApiUrl}get-top-meditators';
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<dynamic> leaderboardJson = jsonData['data'];

      await cacheManager.putFile(
        url,
        response.bodyBytes,
        fileExtension: 'json',
        maxAge: const Duration(minutes: 10),
      );

      return leaderboardJson.map((jsonItem) => LeaderboardModel.fromJson(jsonItem)).toList();
    } else {
      throw Exception('Failed to fetch leaderboards');
    }
  }

  Future<String> fetchCachedLeaderboards(String token) async {
    final url = '${liveApiUrl}get-top-meditators';
    final cacheFile = await cacheManager.getFileFromCache(url);

    if (cacheFile != null && await cacheFile.file.exists()) {
      final fileContent = await cacheFile.file.readAsString();
      return fileContent;
    } else {
      throw Exception('Cache file not found');
    }
  }

  @override
  Future<StreakModel> getStreak(String token) async {
    final url = '${liveApiUrl}get-streak';
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return StreakModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to fetch streak');
    }
  }

  @override
  Future<List<PlaylistModel>> getCuratedPlaylists(String token) async {
    final url = '${liveApiUrl}get-all-categories';
    final cacheFile = await cacheManager.getFileFromCache(url);

    List<dynamic> categoriesJson;

    if (cacheFile != null && await cacheFile.file.exists()) {
      final fileContent = await cacheFile.file.readAsString();
      categoriesJson = json.decode(fileContent);
    } else {
      final response = await http.get(
        Uri.parse(url),
      );

      if (response.statusCode == 200) {
        await cacheManager.putFile(
          url,
          response.bodyBytes,
          fileExtension: 'json',
          maxAge: const Duration(hours: 12),
        );
        categoriesJson = json.decode(response.body);
      } else {
        throw Exception('Failed to fetch categories');
      }
    }

    List<List<PlaylistItem>> playlistItemsList = [];

    for (var categoryJson in categoriesJson) {
      final categoryId = categoryJson['term_id'];
      final categoryUrl = '${liveApiUrl}get-single-category?category_id=$categoryId';
      final categoryCacheFile = await cacheManager.getFileFromCache(categoryUrl);

      List<dynamic> playlistsJson;

      if (categoryCacheFile != null && await categoryCacheFile.file.exists()) {
        final fileContent = await categoryCacheFile.file.readAsString();
        playlistsJson = json.decode(fileContent);
      } else {
        final categoryResponse = await http.get(
          Uri.parse(categoryUrl),
        );

        if (categoryResponse.statusCode == 200) {
          await cacheManager.putFile(
            categoryUrl,
            categoryResponse.bodyBytes,
            fileExtension: 'json',
            maxAge: const Duration(hours: 12),
          );
          playlistsJson = json.decode(categoryResponse.body);
        } else {
          throw Exception('Failed to fetch category data');
        }
      }

      List<PlaylistItem> playlistItems = [];

      for (var playlistJson in playlistsJson) {
        final playlistId = playlistJson['playlist_id'];
        final playlistMeditationsUrl = '${liveApiUrl}get-playlist-meditations?playlist_id=$playlistId';
        final meditationsCacheFile = await cacheManager.getFileFromCache(playlistMeditationsUrl);

        List<dynamic> meditationsJson;

        if (meditationsCacheFile != null && await meditationsCacheFile.file.exists()) {
          final fileContent = await meditationsCacheFile.file.readAsString();
          meditationsJson = json.decode(fileContent)['data'];
        } else {
          final meditationsResponse = await http.get(
            Uri.parse(playlistMeditationsUrl),
            headers: {
              'Authorization': 'Bearer $token',
            },
          );

          if (meditationsResponse.statusCode == 200) {
            await cacheManager.putFile(
              playlistMeditationsUrl,
              meditationsResponse.bodyBytes,
              fileExtension: 'json',
              maxAge: const Duration(hours: 12),
            );
            meditationsJson = json.decode(meditationsResponse.body)['data'];
          } else {
            throw Exception('Failed to fetch meditations data');
          }
        }

        List<AudioSectionModel> audios = AudioSectionModel.fromJsonList(meditationsJson);
        playlistItems.add(PlaylistItem.fromJson(playlistJson, audios));
      }

      playlistItemsList.add(playlistItems);
    }

    final result = PlaylistModel.fromJsonList(categoriesJson, playlistItemsList);
    return result;
  }

  @override
  Future<List<AudioSectionModel>> updateAudioList(
      String token, List<AudioSectionModel> oldAudios, int playlistId) async {
    List<AudioSectionModel?> updatedAudios = [];

    for (var audio in oldAudios) {
      try {
        final updatedAudio = await fetchAndUpdateAudio(token, audio.id, playlistId);
        updatedAudios.add(updatedAudio);
      } catch (e) {
        print("Failed to update audio: $e");
        updatedAudios.add(null);
      }
    }

    return updatedAudios.whereType<AudioSectionModel>().toList();
  }

  Future<AudioSectionModel?> fetchAndUpdateAudio(String token, int libraryId, int playlistId) async {
    final url = '${liveApiUrl}get-single-audio?library_id=$libraryId';
    final cacheFile = await cacheManager.getFileFromCache(url);

    if (cacheFile != null && await cacheFile.file.exists()) {
      final fileContent = await cacheFile.file.readAsString();
      final audioData = json.decode(fileContent)['data'];
      return AudioSectionModel.fromJson(audioData);
    }

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        await cacheManager.putFile(
          url,
          response.bodyBytes,
          fileExtension: 'json',
          maxAge: const Duration(hours: 12),
        );
        final audioData = json.decode(response.body)['data'];
        print('Data fetched from network for libraryId: $libraryId');
        return AudioSectionModel.fromJson(audioData);
      } else {
        throw Exception('Failed to fetch audio data');
      }
    } catch (e) {
      print('Failed to fetch audio data for libraryId: $libraryId: $e');
      return null;
    }
  }

  @override
  Future<List<PlaylistItem>> getUserPlaylists(String token) async {
    final url = '${liveApiUrl}get-user-playlists';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch playlists');
    }

    final playlistsJson = json.decode(response.body)['data'] as List<dynamic>;

    List<PlaylistItem> playlists = [];

    for (var playlistJson in playlistsJson) {
      final playlistId = playlistJson['id'];
      final playlistContent = playlistJson['playlist_content'];

      List<int> libraryIds = [];

      // Handle both object and list cases for playlist_content
      if (playlistContent is List) {
        // Case when playlist_content is a list
        libraryIds = List<int>.from(playlistContent);
      } else if (playlistContent is Map) {
        // Case when playlist_content is an object
        libraryIds = playlistContent.values.cast<int>().toList();
      } else {
        throw Exception('Unexpected playlist_content format');
      }

      List<AudioSectionModel> audios = [];

      for (var libraryId in libraryIds) {
        final audioUrl = '${liveApiUrl}get-single-audio?library_id=$libraryId&playlist_id=$playlistId';

        try {
          final audioResponse = await http.get(
            Uri.parse(audioUrl),
            headers: {
              'Authorization': 'Bearer $token',
            },
          );

          if (audioResponse.statusCode == 200) {
            final audioJson = json.decode(audioResponse.body)['data'];
            audios.add(AudioSectionModel.fromJson(audioJson));
          } else {
            throw Exception('Failed to fetch audio data: ${audioResponse.statusCode}');
          }
        } catch (e) {
          print('Error fetching audio data: $e');
          throw Exception('Failed to fetch audio data');
        }
      }

      playlists.add(PlaylistItem.fromJson(playlistJson, audios));
    }

    return playlists;
  }

  @override
  Future<List<PlaylistItem>> getUserPlaylistsSimple(String token) async {
    final url = '${liveApiUrl}get-user-playlists';

    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch playlists');
    }

    final playlistsJson = json.decode(response.body)['data'] as List<dynamic>;

    List<PlaylistItem> playlists = [];

    for (var playlistJson in playlistsJson) {
      final playlistContent = playlistJson['playlist_content'];

      List<int> libraryIds = [];

      if (playlistContent is List) {
        libraryIds = List<int>.from(playlistContent);
      } else if (playlistContent is Map) {
        libraryIds = playlistContent.values.cast<int>().toList();
      } else {
        throw Exception('Unexpected playlist_content format');
      }

      List<AudioSectionModel> audios = [];

      for (var libraryId in libraryIds) {
        audios.add(AudioSectionModel(
            id: libraryId,
            title: "",
            image: "",
            time: "",
            description: "",
            audioURL: "",
            originalURL: "",
            isDownloaded: false,
            isLiked: false,
            unlocked: false,
            isAddedToPlaylist: false,
            numOfLikes: 0,
            savedInPlaylists: [],
            savedInVaults: []));
      }

      playlists.add(PlaylistItem.fromJson(playlistJson, audios));
    }

    return playlists;
  }

  @override
  Future<void> createPlaylist(String name, String token) async {
    final url = '${liveApiUrl}create-playlist?name=$name';
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to create playlist');
    }
  }

  @override
  Future<void> deletePlaylist(int id, String token) async {
    final url = '${liveApiUrl}remove-playlist';
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'id': id}),
    );

    if (response.statusCode != 200) {
      print('Failed to delete playlist: ${response.statusCode}');
      print('Response body: ${response.body}');
      throw Exception('Failed to delete playlist');
    }
  }

  @override
  Future<void> editPlaylistName(int id, String newName, String token) async {
    final url = '${liveApiUrl}edit-playlist?id=$id&name=$newName';
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to edit playlist name');
    }
  }

  @override
  Future<void> addAudioToPlaylist(int audioID, int playlistID, String token) async {
    final url = '${liveApiUrl}add-to-playlist?audio_id=$audioID&id=$playlistID';
    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to add audio to playlist');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to add audio to playlist');
    }
  }

  @override
  Future<void> removeAudiosFromPlaylists(int audioID, List<int> playlistIDs, String token) async {
    final url = '${liveApiUrl}remove-from-playlist?playlist_ids=$playlistIDs&audio_id=$audioID';
    print(url);
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to remove audio from playlists');
    }
  }

  @override
  Future<void> addLike(int libraryID, String token) async {
    final url = '${liveApiUrl}add-like?library_id=$libraryID';
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to add like');
    }
  }

  @override
  Future<void> removeLike(int libraryID, String token) async {
    final url = '${liveApiUrl}remove-like?library_id=$libraryID';
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to remove like');
    }
  }

  @override
  Future<String> increaseStreak(String timezone, String token) async {
    final url = '${liveApiUrl}increase-streak?tz=$timezone';
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to increase streak');
    }

    final responseData = jsonDecode(response.body);
    final message = responseData['message'];
    final streak = responseData['data']['streak'];

    return '$message Streak: $streak';
  }

  @override
  Future<String> getDashboard(String token) async {
    final url = '${liveApiUrl}get-dashboard';
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to get dashboard');
    }

    final responseData = jsonDecode(response.body);
    final message = responseData['subscription_status'];

    return '$message';
  }

  @override
  Future<List<ResourcesModel>> getResources(String token, String type) async {
    final url = '${liveApiUrl}get-resources?category=$type';
    final cacheFile = await cacheManager.getFileFromCache(url);

    if (cacheFile != null && await cacheFile.file.exists()) {
      final fileContent = await cacheFile.file.readAsString();
      final List<dynamic> jsonResponse = json.decode(fileContent);
      return jsonResponse.map((json) => ResourcesModel.fromJson(json, type)).toList();
    }

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        await cacheManager.putFile(
          url,
          response.bodyBytes,
          fileExtension: 'json',
          maxAge: const Duration(hours: 12),
        );
        final jsonResponse = json.decode(response.body) as List<dynamic>;
        print('Data fetched from network');
        return jsonResponse.map((json) => ResourcesModel.fromJson(json, type)).toList();
      } else {
        throw Exception('Failed to fetch resources');
      }
    } catch (e) {
      print('Failed to fetch resources: $e');
      throw Exception('Failed to fetch resources: $e');
    }
  }

  @override
  Future<List<AudioSectionModel>> getPlaylistMeditations(String token, int playlistId) async {
    final url = '${liveApiUrl}get-playlist-meditations?playlist_id=$playlistId';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        await cacheManager.putFile(
          url,
          response.bodyBytes,
          fileExtension: 'json',
          maxAge: const Duration(hours: 12),
        );
        final jsonResponse = json.decode(response.body);
        print('Data fetched from network');
        return AudioSectionModel.fromJsonList(jsonResponse['data']);
      } else {
        throw Exception('Failed to fetch playlist meditations');
      }
    } catch (e) {
      print('Failed to fetch playlist meditations: $e');
      throw Exception('Failed to fetch playlist meditations: $e');
    }
  }
}
