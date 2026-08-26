import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateInfo {
  final bool hasUpdate;
  final String latestVersion;
  final String currentVersion;
  final String downloadUrl;
  final String releaseNotes;

  UpdateInfo({
    required this.hasUpdate,
    required this.latestVersion,
    required this.currentVersion,
    required this.downloadUrl,
    required this.releaseNotes,
  });
}

class UpdaterService {
  // CLIENT ACTION REQUIRED: Replace OWNER/REPO with actual repository path
  static const String _versionUrl = 'https://raw.githubusercontent.com/nodetologic-projects/star_electricworks_erp/main/version.json';

  Future<UpdateInfo?> checkForUpdates() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final currentVersion = packageInfo.version;

      final response = await http.get(Uri.parse(_versionUrl)).timeout(const Duration(seconds: 10));
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final latestVersion = data['latestVersion'] as String;
        final downloadUrl = data['downloadUrl'] as String;
        final releaseNotes = data['releaseNotes'] as String? ?? '';

        final hasUpdate = _isNewer(latestVersion, currentVersion);

        return UpdateInfo(
          hasUpdate: hasUpdate,
          latestVersion: latestVersion,
          currentVersion: currentVersion,
          downloadUrl: downloadUrl,
          releaseNotes: releaseNotes,
        );
      }
    } catch (e) {
      // Silent failure as requested
    }
    return null;
  }

  Future<void> launchDownloadUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
    }
  }

  bool _isNewer(String remote, String local) {
    try {
      final remoteParts = remote.split('.').map(int.parse).toList();
      final localParts = local.split('.').map(int.parse).toList();

      for (var i = 0; i < 3; i++) {
        final r = i < remoteParts.length ? remoteParts[i] : 0;
        final l = i < localParts.length ? localParts[i] : 0;
        
        if (r > l) return true;
        if (r < l) return false;
      }
    } catch (e) {
      // Silent failure as requested
    }
    return false;
  }
}

final updaterServiceProvider = Provider((ref) => UpdaterService());
