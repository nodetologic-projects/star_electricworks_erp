import 'package:starelectricerp/core/utils/permission_util.dart';
import 'package:path/path.dart' as p;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:starelectricerp/core/theme/app_theme.dart';
import 'package:starelectricerp/core/widgets/app_layout.dart';
import 'package:starelectricerp/core/widgets/app_button.dart';
import 'package:starelectricerp/core/updater/updater_service.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'package:starelectricerp/features/auth/providers/auth_provider.dart';

import 'package:starelectricerp/data/repositories/settings_repository.dart';
import 'package:starelectricerp/data/tables/enums.dart';
import 'package:starelectricerp/core/backup/backup_provider.dart';
import 'package:intl/intl.dart';
import 'package:starelectricerp/core/widgets/app_text_field.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final _storage = const FlutterSecureStorage();
  final _passwordController = TextEditingController();
  final _dllController = TextEditingController(text: r'C:\Windows\System32\eps2003csp11.dll');
  String? _selectedPfxPath;
  DscSigningMethod _signingMethod = DscSigningMethod.fileBased;
  bool _eInvoiceApplicable = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final settingsRepo = ref.read(settingsRepositoryProvider);
    final settings = await settingsRepo.getSettings();
    final pwd = await _storage.read(key: 'dsc_password');
    
    if (mounted) {
      setState(() {
        _selectedPfxPath = settings.dscCertPath;
        _signingMethod = settings.dscSigningMethod ?? DscSigningMethod.fileBased;
        _eInvoiceApplicable = settings.eInvoiceApplicable;
        if (settings.dscPkcs11DllPath != null && settings.dscPkcs11DllPath!.isNotEmpty) {
          _dllController.text = settings.dscPkcs11DllPath!;
        }
        if (pwd != null) {
          _passwordController.text = pwd;
        }
      });
    }
  }

  Future<void> _pickFile() async {
    final hasPermission = await PermissionUtil.requestStoragePermission();
    if (!hasPermission) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Storage permission denied')));
      return;
    }
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pfx', 'p12'],
    );

    if (result.isNotEmpty && result.single.path != null) {
      setState(() {
        _selectedPfxPath = result.single.path;
      });
    }
  }

  Future<void> _saveSettings() async {
    setState(() => _isLoading = true);
    
    try {
      final settingsRepo = ref.read(settingsRepositoryProvider);
      final currentSettings = await settingsRepo.getSettings();
      
      await settingsRepo.updateSettings(currentSettings.toCompanion(true).copyWith(
        dscCertPath: drift.Value(_selectedPfxPath),
        dscSigningMethod: drift.Value(_signingMethod),
        dscPkcs11DllPath: drift.Value(_dllController.text),
        eInvoiceApplicable: drift.Value(_eInvoiceApplicable),
      ));

      await _storage.write(key: 'dsc_password', value: _passwordController.text);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Settings saved successfully.')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save settings: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      currentRoute: '/settings',
      appBar: AppBar(title: const Text('Settings')),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                    'Settings',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 32),
                  
                  // DSC Settings Card
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Digital Signature Certificate (DSC)', style: Theme.of(context).textTheme.titleLarge),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<DscSigningMethod>(
                            initialValue: _signingMethod,
                            decoration: const InputDecoration(
                              labelText: 'Signing Method',
                              border: OutlineInputBorder(),
                            ),
                            items: const [
                              DropdownMenuItem(value: DscSigningMethod.fileBased, child: Text('File-based (.pfx)')),
                              DropdownMenuItem(value: DscSigningMethod.usbToken, child: Text('USB Token (Hardware)')),
                            ],
                            onChanged: (val) {
                              if (val != null) setState(() => _signingMethod = val);
                            },
                          ),
                          const SizedBox(height: 16),
                          
                          if (_signingMethod == DscSigningMethod.fileBased) ...[
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    _selectedPfxPath ?? 'No .pfx / .p12 certificate selected',
                                    style: TextStyle(
                                      color: _selectedPfxPath == null ? Colors.grey : AppTheme.textPrimary,
                                    ),
                                  ),
                                ),
                                OutlinedButton.icon(
                                  icon: const Icon(Icons.folder_open),
                                  label: const Text('Browse'),
                                  onPressed: _pickFile,
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: 300,
                              child: AppTextField(
                                label: 'Certificate Password',
                                controller: _passwordController,
                                obscureText: true,
                              ),
                            ),
                          ] else ...[
                            SizedBox(
                              width: 400,
                              child: AppTextField(
                                label: 'PKCS#11 Driver DLL Path',
                                controller: _dllController,
                              ),
                            ),
                          ],
                          const SizedBox(height: 32),
                          const Divider(),
                          const SizedBox(height: 32),
                
                
                Text('Offline Local Backup', style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Consumer(builder: (context, ref, child) {
                      final backupService = ref.read(backupServiceProvider);
                      
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Backup your data to a local folder, USB drive, or external storage. '
                            'This includes your database, company logo, and signed invoice PDFs.',
                            style: TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 24),
                          Wrap(
                            spacing: 16,
                            runSpacing: 16,
                            children: [
                              AppButton(
                                label: 'Export Backup Now',
                                onPressed: () async {
                                  final hasPermission = await PermissionUtil.requestStoragePermission();
                                  if (!hasPermission) {
                                    if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Storage permission denied')));
                                    return;
                                  }
                                  final result = await FilePicker.getDirectoryPath(dialogTitle: 'Select folder to save backup');
                                  
                                  if (result != null && context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Exporting backup... Please wait.')),
                                    );
                                    
                                    final fullPath = p.join(result, 'backup_${DateFormat("yyyy-MM-dd_HHmm").format(DateTime.now())}.zip');
                                    final success = await backupService.exportLocalBackup(fullPath);
                                    
                                    if (context.mounted) {
                                      final scaffoldMessenger = ScaffoldMessenger.of(context);
                                      if (success) {
                                        final file = File(fullPath);
                                        final size = await file.length();
                                        final sizeKb = (size / 1024).toStringAsFixed(1);
                                        scaffoldMessenger.showSnackBar(
                                          SnackBar(content: Text('Backup exported successfully ($sizeKb KB)!')),
                                        );
                                      } else {
                                        scaffoldMessenger.showSnackBar(
                                          const SnackBar(content: Text('Failed to export backup.')),
                                        );
                                      }
                                    }
                                  }
                                },
                              ),
                              AppButton(
                                label: 'Restore from Local Backup',
                                variant: AppButtonVariant.secondary,
                                onPressed: () async {
                                  final hasPermission = await PermissionUtil.requestStoragePermission();
    if (!hasPermission) {
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Storage permission denied')));
      return;
    }
    final result = await FilePicker.pickFiles(
                                    type: FileType.custom,
                                    allowedExtensions: ['zip'],
                                  );
                                  
                                  if (result.isNotEmpty && result.single.path != null && context.mounted) {
                                    final confirm = await showDialog<bool>(
                                      context: context,
                                      builder: (ctx) => AlertDialog(
                                        title: const Text('Confirm Restore'),
                                        content: const Text('This will replace all current data with the selected backup. A safety copy of your current data will be kept, but continue only if you\'re sure.'),
                                        actions: [
                                          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
                                          TextButton(
                                            onPressed: () => Navigator.pop(ctx, true), 
                                            child: const Text('Restore', style: TextStyle(color: Colors.red)),
                                          ),
                                        ],
                                      )
                                    );
                                    
                                    if (confirm == true && context.mounted) {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text('Restoring backup... Please wait.')),
                                      );
                                      
                                      final success = await backupService.restoreLocalBackup(result.single.path!);
                                      
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(success ? 'Restore successful! Please restart the app.' : 'Restore failed. Invalid backup format or corrupted file.'),
                                            duration: const Duration(seconds: 10),
                                          ),
                                        );
                                      }
                                    }
                                  }
                                },
                              ),
                            ],
                          ),
                        ],
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 32),

                Text('Cloud Backup (Google Drive)', style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 16),
                
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Consumer(builder: (context, ref, child) {
                      final backupService = ref.read(backupServiceProvider);
                      
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FutureBuilder<bool>(
                            future: backupService.provider.isAuthenticated(),
                            builder: (context, snapshot) {
                              final isAuthenticated = snapshot.data ?? false;
                              return Wrap(
                                spacing: 16,
                                runSpacing: 16,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        isAuthenticated ? Icons.cloud_done : Icons.cloud_off, 
                                        color: isAuthenticated ? Colors.green : Colors.grey
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        isAuthenticated ? 'Google Drive Connected' : 'Google Drive Not Connected',
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  if (!isAuthenticated)
                                    AppButton(
                                      label: 'Connect',
                                      onPressed: () async {
                                        final success = await backupService.provider.authenticate();
                                        if (success && context.mounted) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text('Connected to Google Drive successfully!')),
                                          );
                                          // Refresh UI
                                          ref.invalidate(backupServiceProvider); 
                                        }
                                      },
                                    )
                                  else
                                    AppButton(
                                      label: 'Disconnect',
                                      variant: AppButtonVariant.secondary,
                                      onPressed: () async {
                                        await backupService.provider.logout();
                                        if (context.mounted) ref.invalidate(backupServiceProvider);
                                      },
                                    ),
                                ],
                              );
                            },
                          ),
                          const Divider(height: 32),
                          Wrap(
                            spacing: 16,
                            runSpacing: 16,
                            children: [
                              AppButton(
                                label: 'Backup Now',
                                onPressed: () async {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Starting backup...')),
                                  );
                                  final success = await backupService.performBackup();
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text(success ? 'Backup completed successfully!' : 'Backup failed. Please check connection.')),
                                    );
                                  }
                                },
                              ),
                              AppButton(
                                label: 'Restore from Backup',
                                variant: AppButtonVariant.secondary,
                                onPressed: () => _showRestoreDialog(context, ref),
                              ),
                            ],
                          ),
                        ],
                      );
                    }),
                  ),
                ),
                
                const SizedBox(height: 32),
                Text('Software Updates', style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Consumer(builder: (context, ref, child) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Check for Updates', style: Theme.of(context).textTheme.titleMedium),
                              const SizedBox(height: 4),
                              FutureBuilder<PackageInfo>(
                                future: PackageInfo.fromPlatform(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return Text('Current version: ${snapshot.data!.version}', style: const TextStyle(color: Colors.grey));
                                  }
                                  return const Text('Loading version...' , style: TextStyle(color: Colors.grey));
                                },
                              ),
                            ],
                          ),
                          AppButton(
                            label: 'Check Now',
                            variant: AppButtonVariant.secondary,
                            onPressed: () async {
                              final updater = ref.read(updaterServiceProvider);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Checking for updates...')),
                              );
                              final updateInfo = await updater.checkForUpdates();
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                                if (updateInfo == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Failed to check for updates. Check your connection.')),
                                  );
                                } else if (updateInfo.hasUpdate) {
                                  showDialog(
                                    context: context,
                                    builder: (ctx) => AlertDialog(
                                      title: Text('Update Available (${updateInfo.latestVersion})'),
                                      content: Text('Release Notes:\\n${updateInfo.releaseNotes}'),
                                      actions: [
                                        TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(ctx);
                                            updater.launchDownloadUrl(updateInfo.downloadUrl);
                                          },
                                          child: const Text('Download'),
                                        ),
                                      ],
                                    ),
                                  );
                                } else {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('You are up to date!')),
                                  );
                                }
                              }
                            },
                          ),
                        ],
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 32),
                Text('App Lock', style: Theme.of(context).textTheme.headlineSmall),
                const SizedBox(height: 16),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Consumer(builder: (context, ref, child) {
                      final authState = ref.watch(authProvider);
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Enable PIN Lock', style: Theme.of(context).textTheme.titleMedium),
                                  const SizedBox(height: 4),
                                  const Text('Deters casual access to the application.', style: TextStyle(color: Colors.grey)),
                                  if (authState.isPinEnabled)
                                    const Text('WARNING: Losing your PIN means you will have to restore the app entirely.', style: TextStyle(color: Colors.red, fontSize: 12)),
                                ],
                              ),
                              Switch(
                                value: authState.isPinEnabled,
                                onChanged: (val) {
                                  if (val) {
                                    _showSetupPinDialog(context, ref);
                                  } else {
                                    _showDisablePinDialog(context, ref);
                                  }
                                },
                              ),
                            ],
                          ),
                          if (authState.isPinEnabled) ...[
                            const Divider(height: 32),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Lock after inactivity'),
                                DropdownButton<int>(
                                  value: authState.inactivityTimeoutMinutes,
                                  items: const [
                                    DropdownMenuItem(value: 0, child: Text('Never')),
                                    DropdownMenuItem(value: 5, child: Text('5 minutes')),
                                    DropdownMenuItem(value: 15, child: Text('15 minutes')),
                                    DropdownMenuItem(value: 30, child: Text('30 minutes')),
                                  ],
                                  onChanged: (val) {
                                    if (val != null) {
                                      ref.read(authProvider.notifier).updateInactivityTimeout(val);
                                    }
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            AppButton(
                              label: 'Change PIN',
                              variant: AppButtonVariant.secondary,
                              onPressed: () => _showChangePinDialog(context, ref),
                            ),
                          ],
                        ],
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 32),
                Text('Danger Zone', style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: Colors.red)),
                          const SizedBox(height: 16),
                          Tooltip(
                            message: "Only enable this if your CA has confirmed you're required to generate e-Invoices (IRN) — this is based on annual turnover, not per-invoice amount.",
                            child: SwitchListTile(
                              title: const Text('e-Invoice (IRN) Applicable'),
                              subtitle: const Text('Check this if your business turnover mandates e-Invoicing.'),
                              value: _eInvoiceApplicable,
                              onChanged: (val) {
                                setState(() => _eInvoiceApplicable = val);
                              },
                            ),
                          ),
                          
                          const SizedBox(height: 24),
                          AppButton(
                            label: 'Save Settings',
                            onPressed: _saveSettings,
                            isLoading: _isLoading,
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ),
    );
  }

  void _showSetupPinDialog(BuildContext context, WidgetRef ref) {
    final pinController = TextEditingController();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('Set PIN'),
        content: TextField(
          controller: pinController,
          obscureText: true,
          keyboardType: TextInputType.number,
          maxLength: 6,
          decoration: const InputDecoration(labelText: '4-6 digit PIN'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              final pin = pinController.text;
              if (pin.length >= 4) {
                ref.read(authProvider.notifier).setPin(pin);
                Navigator.pop(ctx);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showDisablePinDialog(BuildContext context, WidgetRef ref) {
    final pinController = TextEditingController();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('Disable PIN Lock'),
        content: TextField(
          controller: pinController,
          obscureText: true,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(labelText: 'Current PIN'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              final pin = pinController.text;
              final success = await ref.read(authProvider.notifier).disablePin(pin);
              if (ctx.mounted) {
                if (success) {
                  Navigator.pop(ctx);
                } else {
                  ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(content: Text('Incorrect PIN')));
                }
              }
            },
            child: const Text('Disable', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showChangePinDialog(BuildContext context, WidgetRef ref) {
    final oldPinController = TextEditingController();
    final newPinController = TextEditingController();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text('Change PIN'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: oldPinController,
              obscureText: true,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Current PIN'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: newPinController,
              obscureText: true,
              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: const InputDecoration(labelText: 'New 4-6 digit PIN'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              final oldPin = oldPinController.text;
              final newPin = newPinController.text;
              if (newPin.length >= 4) {
                final success = await ref.read(authProvider.notifier).changePin(oldPin, newPin);
                if (ctx.mounted) {
                  if (success) {
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(content: Text('PIN changed successfully')));
                  } else {
                    ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(content: Text('Incorrect current PIN')));
                  }
                }
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showRestoreDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Restore from Backup'),
          content: SizedBox(
            width: double.maxFinite,
            height: 300,
            child: Consumer(builder: (context, ref, child) {
              final backupService = ref.read(backupServiceProvider);
              
              return FutureBuilder(
                future: backupService.provider.listBackups(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  
                  if (snapshot.hasError) {
                    return Center(child: Text('Error loading backups: ${snapshot.error}'));
                  }
                  
                  final backups = snapshot.data;
                  if (backups == null || backups.isEmpty) {
                    return const Center(child: Text('No backups found.'));
                  }
                  
                  return ListView.builder(
                    itemCount: backups.length,
                    itemBuilder: (context, index) {
                      final backup = backups[index];
                      final dateStr = backup.modifiedTime != null 
                          ? DateFormat('dd MMM yyyy, hh:mm a').format(backup.modifiedTime!) 
                          : 'Unknown Date';
                      
                      return ListTile(
                        leading: const Icon(Icons.archive),
                        title: Text(backup.name),
                        subtitle: Text(dateStr),
                        trailing: TextButton(
                          onPressed: () async {
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: const Text('Confirm Restore'),
                                content: const Text('This will replace your current database with the backup. A safety copy of your current database will be saved locally. The app must be restarted after restoration. Proceed?'),
                                actions: [
                                  TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
                                  TextButton(
                                    onPressed: () => Navigator.pop(ctx, true), 
                                    child: const Text('Restore', style: TextStyle(color: Colors.red)),
                                  ),
                                ],
                              )
                            );
                            
                            if (confirm == true && context.mounted) {
                              Navigator.pop(context); // close restore list
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Restoring backup... Please wait.')),
                              );
                              final success = await backupService.restoreBackup(backup.id);
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(success ? 'Restore successful! Please restart the app.' : 'Restore failed.'),
                                    duration: const Duration(seconds: 10),
                                  ),
                                );
                              }
                            }
                          },
                          child: const Text('Restore'),
                        ),
                      );
                    },
                  );
                },
              );
            }),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Close'),
            ),
          ],
        );
      }
    );
  }
}
