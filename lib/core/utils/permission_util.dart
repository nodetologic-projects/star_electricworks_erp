import 'dart:io';

class PermissionUtil {
  static Future<bool> requestStoragePermission() async {
    // Desktop platforms (Windows/macOS) handle file access via native dialogs
    // Explicit runtime permissions are unnecessary for this application's target platform.
    return true;
  }
}
