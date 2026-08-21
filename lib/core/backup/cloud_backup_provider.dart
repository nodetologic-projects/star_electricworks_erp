import 'dart:io';

abstract class CloudBackupProvider {
  /// Name of the provider (e.g. "Google Drive")
  String get name;

  /// Returns true if currently authenticated.
  Future<bool> isAuthenticated();

  /// Authenticate the user. Returns true if successful.
  Future<bool> authenticate();

  /// Log out the user.
  Future<void> logout();

  /// Uploads a backup file. Returns the file ID/URI if successful.
  Future<String> uploadBackup(File file, {required String description});

  /// Lists available backups, returning a map of File ID -> File Name / Date.
  Future<List<CloudBackupFile>> listBackups();

  /// Downloads a backup by ID to the specified destination file.
  Future<void> downloadBackup(String fileId, File destination);
}

class CloudBackupFile {
  final String id;
  final String name;
  final DateTime? modifiedTime;
  final int? sizeBytes;

  CloudBackupFile({
    required this.id,
    required this.name,
    this.modifiedTime,
    this.sizeBytes,
  });
}
