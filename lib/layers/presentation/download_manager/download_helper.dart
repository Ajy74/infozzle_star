import 'dart:io';

import 'package:path_provider/path_provider.dart';

class DownloadHelper {
  static Future<String?> getDownloadedPath(int audioId) async {
    final directory = await getApplicationDocumentsDirectory();
    List<FileSystemEntity> files = directory.listSync();

    for (FileSystemEntity file in files) {
      if (file is File) {
        String fileName = file.path.split('/').last;
        List<String> parts = fileName.split('_');
        if (parts.length >= 2 && parts[0] == audioId.toString()) {
          return file.path;
        }
      }
    }
    return null;
  }
}
