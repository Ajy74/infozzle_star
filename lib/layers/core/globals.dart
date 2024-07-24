library my_globals;

import 'dart:convert';
import 'dart:io';

import 'package:breathpacer/layers/domain/models/vaults_model.dart';
import 'package:breathpacer/layers/domain/use_cases/database/get_dashboard_use_case.dart';
import 'package:breathpacer/layers/domain/use_cases/user/get_user_use_case.dart';
import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toastification/toastification.dart';

import '../../helpers/token_expiration.dart';
import '../domain/models/light_language_audio.dart';

String globalUsername = "Guest";
bool globalLoggedIn = true;
bool globalIsActive = true;
final GetUserUseCase getUserUseCase = GetUserUseCase();
final GetDashboardUseCase getDashboardUseCase = GetDashboardUseCase();

Future<void> globalCheckIfLoggedIn() async {
  final token = await globalGetToken();
  final tokenExpires = await globalGetTokenExpires();

  if (token != null && tokenExpires != null) {
    final currentTime = DateTime.now().millisecondsSinceEpoch / 1000;
    if (currentTime < tokenExpires) {
      try {
        await getUser(token);
        final isActive = await getDashboardUseCase.execute(token);
        if (isActive == "active") {
          globalIsActive = true;
        }
        globalLoggedIn = true;
      } catch (e) {
        globalIsActive = false;
        globalLoggedIn = false;
        if (e is TokenExpiredException) {
          print("Token expired!");
          await globalSetToken("");
        } else {
          print("Failed to get user: $e");
          await globalSetToken("");
        }
      }
    } else {
      globalIsActive = false;
      globalLoggedIn = false;
      print("Token expired based on time check!");
      await globalSetToken("");
    }
  } else {
    globalIsActive = false;
    globalLoggedIn = false;
  }
}

Future<void> getUser(String token) async {
  try {
    final user = await getUserUseCase.execute(token);
    globalUsername = user.name ?? "Guest";
  } catch (e) {
    await globalSetToken('');
    if (e is TokenExpiredException) {
      throw TokenExpiredException("Token expired!");
    } else {
      throw Exception("Failed to get user: $e");
    }
  }
}

Future<void> globalSetToken(String token) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('token', token);
}

Future<String?> globalGetToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('token');
}

Future<int?> globalGetTokenExpires() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getInt('tokenExpires');
}

Future<List<VaultsModel>?> globalLoadVaults() async {
  final prefs = await SharedPreferences.getInstance();
  final String? vaultsJson = prefs.getString('vaults');
  if (vaultsJson != null) {
    final List<dynamic> decoded = jsonDecode(vaultsJson);
    return VaultsModel.fromJsonList(decoded);
  }
  return [];
}

Future<void> globalAddVault(VaultsModel newVault) async {
  List<VaultsModel>? vaults = await globalLoadVaults();

  if (newVault.title.isNotEmpty && (vaults == null || !vaults.any((vault) => vault.title == newVault.title))) {
    vaults ??= [];
    vaults.add(newVault);
    await globalSaveVaults(vaults);
  } else {
    toastification.show(
      style: ToastificationStyle.flatColored,
      type: ToastificationType.error,
      dragToClose: true,
      alignment: Alignment.bottomCenter,
      autoCloseDuration: const Duration(seconds: 5),
      title: const Text('Invalid Title'),
      description: const Text('Vault title must be unique and not empty.'),
    );
  }
}

Future<void> globalRemoveVault(String title, List<LightLanguageAudioModel> audios) async {
  for (var item in audios) {
    await globalDeleteAudioFromVault(title, item.id);
  }

  List<VaultsModel>? vaults = await globalLoadVaults();
  vaults?.removeWhere((vault) => vault.title == title);
  await globalSaveVaults(vaults ?? []);
}

Future<void> globalRenameVault(String currentTitle, String newTitle) async {
  List<VaultsModel>? vaults = await globalLoadVaults();
  if (vaults != null) {
    for (int i = 0; i < vaults.length; i++) {
      if (vaults[i].title == currentTitle) {
        vaults[i] = vaults[i].copyWith(title: newTitle);
        break;
      }
    }
    await globalSaveVaults(vaults);
  }
}

Future<void> globalSaveVaults(List<VaultsModel> vaults) async {
  final prefs = await SharedPreferences.getInstance();
  final String vaultsJson = jsonEncode(vaults.map((vault) => vault.toJson()).toList());
  await prefs.setString('vaults', vaultsJson);
}

Future<void> globalAddAudioToVault(String vaultTitle, LightLanguageAudioModel newAudio) async {
  List<VaultsModel>? vaults = await globalLoadVaults();
  bool isUnique = true;

  if (vaults != null) {
    // Check if the audio ID is already present in any vault
    for (var vault in vaults) {
      if (vault.title == vaultTitle) {
        if (vault.audios.any((audio) => audio.id == newAudio.id)) {
          isUnique = false;
          break;
        }
      }
    }

    if (!isUnique) {
      // Show a toast notification that the file is already added to a vault
      toastification.show(
        style: ToastificationStyle.flatColored,
        type: ToastificationType.success,
        dragToClose: true,
        alignment: Alignment.bottomCenter,
        autoCloseDuration: const Duration(seconds: 5),
        title: const Text('Already Added'),
        description: const Text('File already added to vault'),
      );
      return;
    }

    // If unique, add the new audio to the specified vault
    for (int i = 0; i < vaults.length; i++) {
      if (vaults[i].title == vaultTitle) {
        List<LightLanguageAudioModel> updatedAudios = List.from(vaults[i].audios)..add(newAudio);
        vaults[i] = vaults[i].copyWith(audios: updatedAudios);
        break;
      }
    }

    // Save the updated vaults list to SharedPreferences
    await globalSaveVaults(vaults);
  }
}

Future<void> globalDeleteAudioFromVault(String vaultTitle, int audioId) async {
  // Step 1: Delete from the vaults list in SharedPreferences
  List<VaultsModel>? vaults = await globalLoadVaults();
  if (vaults != null) {
    for (int i = 0; i < vaults.length; i++) {
      if (vaults[i].title == vaultTitle) {
        List<LightLanguageAudioModel> updatedAudios = List.from(vaults[i].audios)
          ..removeWhere((audio) => audio.id == audioId);
        vaults[i] = vaults[i].copyWith(audios: updatedAudios);
        break;
      }
    }
    await globalSaveVaults(vaults);
  }

  // Step 2: Delete the audio file from the directory
  try {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/${audioId}_$vaultTitle.mp3';
    File file = File(filePath);
    if (await file.exists()) {
      await file.delete();
      print('Deleted file: $filePath');
    } else {
      print('File not found: $filePath');
    }
  } catch (e) {
    print('Error deleting file: $e');
  }
}

bool isAudioInVaults(String audioTitle, List<VaultsModel> vaults) {
  for (var vault in vaults) {
    for (var audio in vault.audios) {
      if (audio.title == audioTitle) {
        return true;
      }
    }
  }
  return false;
}
