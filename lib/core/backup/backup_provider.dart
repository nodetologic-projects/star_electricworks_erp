import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:starelectricerp/core/backup/cloud_backup_provider.dart';
import 'package:starelectricerp/core/backup/google_drive_backup_provider.dart';
import 'package:starelectricerp/core/backup/backup_service.dart';

final cloudBackupProvider = Provider<CloudBackupProvider>((ref) {
  return GoogleDriveBackupProvider();
});

final backupServiceProvider = Provider<BackupService>((ref) {
  final provider = ref.watch(cloudBackupProvider);
  return BackupService(provider);
});
