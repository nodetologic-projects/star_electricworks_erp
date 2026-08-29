import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:starelectricerp/core/widgets/app_layout.dart';

class SupportScreen extends ConsumerStatefulWidget {
  const SupportScreen({super.key});

  @override
  ConsumerState<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends ConsumerState<SupportScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  
  XFile? _attachment;
  bool _isSending = false;

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _attachment = image;
      });
    }
  }

  Future<void> _sendReport() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSending = true);

    try {
      final packageInfo = await PackageInfo.fromPlatform();
      final osVersion = Platform.operatingSystemVersion;
      final osName = Platform.operatingSystem;
      final timestamp = DateTime.now().toIso8601String();

      final deviceInfo = '''
=== Device Info ===
App Version: ${packageInfo.version} (${packageInfo.buildNumber})
OS: $osName $osVersion
Timestamp: $timestamp
===================
''';

      final body = '''
${_descriptionController.text}

$deviceInfo
''';

      String? savedImagePath;
      if (_attachment != null) {
        final downloadsDir = await getDownloadsDirectory();
        if (downloadsDir != null) {
          final destFile = File('${downloadsDir.path}/StarElectric_Issue_${DateTime.now().millisecondsSinceEpoch}.png');
          await File(_attachment!.path).copy(destFile.path);
          savedImagePath = destFile.path;
        }
      }

      final Uri emailLaunchUri = Uri(
        scheme: 'mailto',
        path: 'info.nodetologic@gmail.com',
        query: _encodeQueryParameters(<String, String>{
          'subject': 'Star Electric ERP Support Report',
          'body': body,
        }),
      );

      if (await canLaunchUrl(emailLaunchUri)) {
        await launchUrl(emailLaunchUri);
        
        if (mounted) {
          showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: const Text('Report Prepared'),
              content: Text(
                'Your default email client has been opened.\n\n'
                '${savedImagePath != null ? "IMPORTANT: Since you selected a screenshot, it has been saved to your Downloads folder at:\\n\\n$savedImagePath\\n\\nPlease MANUALLY ATTACH this file to the email before sending." : ""}'
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                    _descriptionController.clear();
                    setState(() => _attachment = null);
                  },
                  child: const Text('OK'),
                )
              ],
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not open default email client.')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSending = false);
      }
    }
  }

  String? _encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((MapEntry<String, String> e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      currentRoute: '/support',
      appBar: AppBar(title: const Text('Support')),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Support',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              const SizedBox(height: 8),
              const Text(
                'This report goes to Nodetologic IT Solutions for app support — not for GST or business queries.',
                style: TextStyle(color: Colors.grey, fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _descriptionController,
                maxLines: 6,
                decoration: const InputDecoration(
                  labelText: 'Describe your issue in detail',
                  border: OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Please enter a description.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  OutlinedButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(Icons.attach_file),
                    label: const Text('Attach Screenshot (Optional)'),
                  ),
                  if (_attachment != null) ...[
                    const SizedBox(width: 16),
                    const Icon(Icons.check_circle, color: Colors.green, size: 20),
                    const SizedBox(width: 4),
                    const Expanded(
                      child: Text('Screenshot attached', style: TextStyle(color: Colors.green)),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.red),
                      onPressed: () => setState(() => _attachment = null),
                      tooltip: 'Remove Attachment',
                    )
                  ]
                ],
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: FilledButton.icon(
                  onPressed: _isSending ? null : _sendReport,
                  icon: _isSending
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Icon(Icons.send),
                  label: const Text('Send Report'),
                  style: FilledButton.styleFrom(
                    backgroundColor: Colors.blue.shade700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
