import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:toastification/toastification.dart';

import '../../../helpers/notification_service.dart';
import '../../core/globals.dart';
import '../../domain/models/audio_section_model.dart';
import '../../domain/models/light_language_audio.dart';
import '../views/pages/playlists/widgets/playlist_list_view.dart';
import 'download_state.dart';

class DownloadViewModel extends Cubit<DownloadState> {
  DownloadViewModel() : super(DownloadState());
  final dio = Dio();

  Future<void> downloadFile(String url, String id, String filename, String vaultName, LightLanguageAudioModel audio,
      Function()? onComplete) async {
    if (!id.endsWith('.mp3')) {
      id += '_$vaultName.mp3';
    }

    print(id);
    print(filename);

    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/$id';

    if (File(filePath).existsSync()) {
      toastification.show(
        style: ToastificationStyle.flatColored,
        type: ToastificationType.info,
        dragToClose: true,
        closeOnClick: true,
        alignment: Alignment.bottomCenter,
        autoCloseDuration: const Duration(seconds: 5),
        title: const Text('Already Added to Vault'),
        description: Text('$filename has already been added to this vault'),
      );
      print('File already exists: $filePath');
      return;
    }

    final notificationService = NotificationService();

    toastification.show(
      style: ToastificationStyle.flatColored,
      type: ToastificationType.info,
      dragToClose: true,
      alignment: Alignment.bottomCenter,
      autoCloseDuration: const Duration(seconds: 5),
      title: const Text('Download Started'),
      description: Text('$filename has started downloading'),
    );

    await dio.download(
      url,
      filePath,
      onReceiveProgress: (received, total) {
        final newDownloadProgress = ((received / total) * 100).toInt();
        Map<String, int> map = Map.from(state.downloadProgressMap);
        int currentProgress = map[url] ?? 0;

        if (currentProgress != newDownloadProgress) {
          if (total != -1) {
            map[url] = newDownloadProgress;
            state.downloadProgressMap = map;

            emit(DownloadState.clone(state));
            notificationService.createNotification(audio.id, newDownloadProgress, 100, 1, 1, filename);
          }
        }
      },
    );

    Map<String, int> map = Map.from(state.downloadProgressMap);
    map.remove(url);
    state.downloadProgressMap = map;
    emit(DownloadState.clone(state));

    notificationService.cancelNotification(audio.id);

    await saveToVault(vaultName, audio);

    onComplete?.call();

    toastification.show(
      style: ToastificationStyle.flatColored,
      type: ToastificationType.success,
      dragToClose: true,
      alignment: Alignment.bottomCenter,
      autoCloseDuration: const Duration(seconds: 5),
      title: const Text('Download Complete'),
      description: Text('$filename has downloaded successfully'),
    );
  }

  Future<void> massDownloadFiles(List<AudioSectionModel> audioSections, String vaultName) async {
    final dio = Dio();
    final toastification = Toastification();
    final notificationService = NotificationService();
    final directory = await getApplicationDocumentsDirectory();

    int totalFiles = audioSections.length;
    int completedDownloads = 0;

    for (final audio in audioSections) {
      String url = audio.audioURL;
      String filename = audio.id.toString();
      if (!filename.endsWith('.mp3')) {
        filename += '_$vaultName.mp3';
      }
      String filePath = '${directory.path}/$filename';

      if (File(filePath).existsSync()) {
        completedDownloads++;
        continue;
      }

      try {
        await dio.download(
          url,
          filePath,
          onReceiveProgress: (received, total) {
            if (total != -1) {
              double fileProgress = received / total;
              double newProgress = (((completedDownloads + fileProgress) / totalFiles) * 100);
              int newProgressInt = newProgress.toInt();

              Map<String, int> map = Map.from(state.downloadProgressMap);
              int totalProgress = map[vaultName] ?? 0;

              if (newProgressInt != totalProgress.toInt()) {
                map[vaultName] = newProgressInt;
                state.downloadProgressMap = map;
                emit(DownloadState.clone(state));

                notificationService.createNotification(
                    vaultName.hashCode, newProgressInt, 100, completedDownloads, totalFiles, vaultName);
              }
            }
          },
        );

        completedDownloads++;

        await saveToVault(vaultName, mapVaultAudio(audio));
      } catch (e) {
        print('Error downloading file, Error: $e');
      }
    }

    Map<String, int> map = Map.from(state.downloadProgressMap);
    map.remove(vaultName);
    state.downloadProgressMap = map;
    emit(DownloadState.clone(state));

    notificationService.cancelNotification(vaultName.hashCode);

    if (completedDownloads == totalFiles) {
      toastification.show(
        style: ToastificationStyle.flatColored,
        type: ToastificationType.success,
        dragToClose: true,
        alignment: Alignment.bottomCenter,
        autoCloseDuration: const Duration(seconds: 5),
        title: const Text('Mass Download Complete'),
        description: Text('$vaultName downloaded successfully'),
      );
    } else {
      toastification.show(
        style: ToastificationStyle.flatColored,
        type: ToastificationType.error,
        dragToClose: true,
        alignment: Alignment.bottomCenter,
        autoCloseDuration: const Duration(seconds: 5),
        title: const Text('Mass Download Failed'),
        description: const Text('Some files failed to download'),
      );
    }
  }

  Future<void> saveToVault(String vault, LightLanguageAudioModel audio) async {
    await globalAddAudioToVault(vault, audio);
  }
}
