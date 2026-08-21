import 'dart:io';
import 'package:permission_handler/permission_handler.dart';

class PermissionUtil {
  static Future<bool> requestStoragePermission() async {
    if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      // Desktop platforms usually rely on native file pickers rather than explicit app permissions
      return true;
    }
    
    // Android / iOS
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      status = await Permission.storage.request();
    }
    
    // For Android 11+ (API 30+) manage external storage
    if (Platform.isAndroid) {
      var manageStatus = await Permission.manageExternalStorage.status;
      if (!manageStatus.isGranted) {
        manageStatus = await Permission.manageExternalStorage.request();
        if (manageStatus.isGranted) {
          return true;
        }
      }
    }

    return status.isGranted;
  }
}
