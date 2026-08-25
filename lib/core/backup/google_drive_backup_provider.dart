import 'package:starelectricerp/core/config/google_credentials.dart';
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import 'cloud_backup_provider.dart';

class GoogleDriveBackupProvider implements CloudBackupProvider {
  // CLIENT ACTION REQUIRED: Replace with your actual GCP OAuth 2.0 Client ID for Desktop
  
   
  
  static const _scopes = [drive.DriveApi.driveFileScope];
  static const _tokenKey = 'gdrive_auth_credentials';
  
  
  AutoRefreshingAuthClient? _authClient;

  @override
  String get name => 'Google Drive';

  @override
  Future<bool> isAuthenticated() async {
    if (_authClient != null) return true;
    
    // Try to load credentials from secure storage
    final prefs = await SharedPreferences.getInstance();
    final tokenJson = prefs.getString(_tokenKey);
    if (tokenJson != null) {
      try {
        final Map<String, dynamic> tokenData = jsonDecode(tokenJson);
        final credentials = AccessCredentials.fromJson(tokenData);
        final clientId = ClientId(GoogleCredentials.clientId, GoogleCredentials.clientSecret);
        _authClient = autoRefreshingClient(clientId, credentials, http.Client());
        return true;
      } catch (e) {
        // Invalid or expired credentials format
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove(_tokenKey);
      }
    }
    return false;
  }

  @override
  Future<bool> authenticate() async {
    if (await isAuthenticated()) return true;

    final clientId = ClientId(GoogleCredentials.clientId, GoogleCredentials.clientSecret);
    
    try {
      _authClient = await clientViaUserConsent(
        clientId, 
        _scopes, 
        (url) async {
          final uri = Uri.parse(url);
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri);
          } else {
            throw Exception('Could not launch Google Sign-In URL');
          }
        }
      );
      
      // Save credentials for future use
      final credentials = _authClient!.credentials;
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_tokenKey, jsonEncode(credentials.toJson()));
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<void> logout() async {
    _authClient?.close();
    _authClient = null;
    final prefs = await SharedPreferences.getInstance();
        await prefs.remove(_tokenKey);
  }

  Future<drive.DriveApi> _getDriveApi() async {
    if (!await isAuthenticated()) {
      throw Exception('Not authenticated with Google Drive');
    }
    return drive.DriveApi(_authClient!);
  }

  Future<String> _getOrAppFolder(drive.DriveApi api) async {
    const folderName = 'Star Electric ERP Backups';
    final query = "name = '$folderName' and mimeType = 'application/vnd.google-apps.folder' and trashed = false";
    final fileList = await api.files.list(q: query, spaces: 'drive');
    
    if (fileList.files != null && fileList.files!.isNotEmpty) {
      return fileList.files!.first.id!;
    }
    
    // Create the folder
    final folder = drive.File()
      ..name = folderName
      ..mimeType = 'application/vnd.google-apps.folder';
      
    final created = await api.files.create(folder);
    return created.id!;
  }

  @override
  Future<String> uploadBackup(File file, {required String description}) async {
    final api = await _getDriveApi();
    final folderId = await _getOrAppFolder(api);
    
    final driveFile = drive.File()
      ..name = file.uri.pathSegments.last
      ..description = description
      ..parents = [folderId];
      
    final media = drive.Media(file.openRead(), file.lengthSync());
    final result = await api.files.create(driveFile, uploadMedia: media);
    return result.id!;
  }

  @override
  Future<List<CloudBackupFile>> listBackups() async {
    final api = await _getDriveApi();
    try {
      final folderId = await _getOrAppFolder(api);
      final query = "'$folderId' in parents and trashed = false";
      
      final fileList = await api.files.list(
        q: query, 
        orderBy: 'createdTime desc',
        $fields: 'files(id, name, modifiedTime, size)'
      );
      
      if (fileList.files == null) return [];
      
      return fileList.files!.map((f) => CloudBackupFile(
        id: f.id!,
        name: f.name ?? 'Unknown',
        modifiedTime: f.modifiedTime,
        sizeBytes: f.size != null ? int.tryParse(f.size!) : null,
      )).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<void> downloadBackup(String fileId, File destination) async {
    final api = await _getDriveApi();
    final media = await api.files.get(fileId, downloadOptions: drive.DownloadOptions.fullMedia) as drive.Media;
    
    final sink = destination.openWrite();
    await media.stream.pipe(sink);
    await sink.flush();
    await sink.close();
  }
}
