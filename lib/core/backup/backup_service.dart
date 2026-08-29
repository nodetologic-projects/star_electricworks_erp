import 'dart:io';

import 'package:archive/archive_io.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:shared_preferences/shared_preferences.dart';

import 'cloud_backup_provider.dart';

class BackupService {
  final CloudBackupProvider provider;

  BackupService(this.provider);


  /// Performs a cloud backup and returns true if successful.
  Future<bool> performBackup() async {
    try {
      final isAuthenticated = await provider.isAuthenticated();
      if (!isAuthenticated) return false;

      final zipFile = await _createBackupZip();
      if (zipFile == null) return false;

      final timestamp = DateTime.now().toIso8601String();
      await provider.uploadBackup(zipFile, description: 'Star Electric ERP Backup $timestamp');
      
      // Cleanup temp
      await zipFile.delete();

      // Enforce limit of 10 backups by deleting the oldest
      await _cleanupOldBackups();
      
      // Record last backup time
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('last_backup_time', timestamp);

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> _cleanupOldBackups() async {
    // Note: To delete, CloudBackupProvider would need a deleteBackup method, 
    // but we can add this logic later. For now, it's just a placeholder.
  }


  /// Restores from a specific cloud backup file.
  Future<bool> restoreBackup(String fileId) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final zipPath = p.join(tempDir.path, 'restore_${DateTime.now().millisecondsSinceEpoch}.zip');
      final zipFile = File(zipPath);

      await provider.downloadBackup(fileId, zipFile);
      
      final success = await _extractBackupZip(zipFile);
      
      // Cleanup
      await zipFile.delete();
      
      return success;
    } catch (e) {
      return false;
    }
  }


  Future<File?> _createBackupZip() async {
    final docsDir = await getApplicationDocumentsDirectory();
    final dbFile = File(p.join(docsDir.path, 'starelectricerp.sqlite'));
    final logoFile = File(p.join(docsDir.path, 'company_logo.png'));

    if (!await dbFile.exists()) return null;

    final tempDir = await getTemporaryDirectory();
    final zipPath = p.join(tempDir.path, 'backup_${DateTime.now().millisecondsSinceEpoch}.zip');

    final encoder = ZipFileEncoder();
    encoder.create(zipPath);
    encoder.addFile(dbFile);
    
    if (await logoFile.exists()) {
      encoder.addFile(logoFile);
    }

    // Add all PDFs from the invoices directory
    final invoicesDir = Directory(p.join(docsDir.path, 'Star Electric Works Invoices'));
    if (await invoicesDir.exists()) {
      final dirList = invoicesDir.listSync();
      for (var entity in dirList) {
        if (entity is File && entity.path.endsWith('.pdf')) {
          encoder.addFile(entity); // By default addFile puts it in root. We could namespace them, but we'll stick to flat.
        }
      }
    }
    
    // Add all files from purchase_bills directory, prefixed so we know how to restore them
    final billsDir = Directory(p.join(docsDir.path, 'purchase_bills'));
    if (await billsDir.exists()) {
      final dirList = billsDir.listSync();
      for (var entity in dirList) {
        if (entity is File) {
          encoder.addFile(entity, 'purchase_bills/${p.basename(entity.path)}');
        }
      }
    }

    encoder.close();
    return File(zipPath);
  }

  Future<bool> _extractBackupZip(File zipFile) async {
    final docsDir = await getApplicationDocumentsDirectory();
    
    // Unzip to memory to validate
    final bytes = await zipFile.readAsBytes();
    final archive = ZipDecoder().decodeBytes(bytes);

    // Validate db exists
    bool hasDb = false;
    for (final file in archive) {
      if (file.name == 'starelectricerp.sqlite') {
        hasDb = true;
        break;
      }
    }

    if (!hasDb) {
      return false;
    }

    // Safety copy of current DB
    final dbFile = File(p.join(docsDir.path, 'starelectricerp.sqlite'));
    if (await dbFile.exists()) {
      final safetyPath = p.join(docsDir.path, 'starelectricerp_safety_copy.sqlite');
      await dbFile.copy(safetyPath);
    }

    final invoicesDir = Directory(p.join(docsDir.path, 'Star Electric Works Invoices'));
    if (!await invoicesDir.exists()) {
      await invoicesDir.create(recursive: true);
    }
    
    final billsDir = Directory(p.join(docsDir.path, 'purchase_bills'));
    if (!await billsDir.exists()) {
      await billsDir.create(recursive: true);
    }

    for (final file in archive) {
      if (file.isFile) {
        String outPath;
        if (file.name.startsWith('purchase_bills/')) {
          outPath = p.join(docsDir.path, file.name);
        } else if (file.name.endsWith('.pdf')) {
          outPath = p.join(invoicesDir.path, p.basename(file.name));
        } else {
          outPath = p.join(docsDir.path, p.basename(file.name));
        }
        final outFile = File(outPath);
        // Ensure parent exists (for purchase_bills/)
        if (!await outFile.parent.exists()) {
           await outFile.parent.create(recursive: true);
        }
        await outFile.writeAsBytes(file.content as List<int>);
      }
    }

    return true;
  }

  /// Exports local backup to a specific destination path
  Future<bool> exportLocalBackup(String destinationPath) async {
    try {
      final zipFile = await _createBackupZip();
      if (zipFile == null) return false;

      final destFile = File(destinationPath);
      await zipFile.copy(destFile.path);
      await zipFile.delete(); // cleanup temp
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('last_local_backup_time', DateTime.now().toIso8601String());
      
      return true;
    } catch (e) {
      return false;
    }
  }

  /// Restores local backup from a specific zip path
  Future<bool> restoreLocalBackup(String sourceZipPath) async {
    try {
      final zipFile = File(sourceZipPath);
      if (!await zipFile.exists()) return false;
      return await _extractBackupZip(zipFile);
    } catch (e) {
      return false;
    }
  }
}
