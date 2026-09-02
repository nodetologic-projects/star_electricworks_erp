import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:path_provider/path_provider.dart';

class DirectPrintService {
  static const String _printerKey = 'last_used_printer';

  static Future<void> printPdf(
    BuildContext context, 
    String fileName, {
    required Future<Uint8List> Function() fallbackGenerate,
    String? explicitPdfPath,
  }) async {
    if (context.mounted) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );
    }

    try {
      Uint8List bytes;
      
      if (explicitPdfPath != null && explicitPdfPath.isNotEmpty) {
        final explicitFile = File(explicitPdfPath);
        if (await explicitFile.exists()) {
          bytes = await explicitFile.readAsBytes();
        } else {
          throw Exception('Explicit PDF path provided but file does not exist: $explicitPdfPath');
        }
      } else {
        bytes = await fallbackGenerate();
      }

      final printers = await Printing.listPrinters();
      
      if (context.mounted) {
        Navigator.of(context).pop(); // remove loading indicator
      }

      if (printers.isEmpty) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No printers found on this system.'), backgroundColor: Colors.red),
          );
        }
        return;
      }

      final prefs = await SharedPreferences.getInstance();
      final lastPrinterUrl = prefs.getString(_printerKey);
      
      Printer? selectedPrinter;
      
      if (printers.length == 1) {
        selectedPrinter = printers.first;
      } else {
        if (context.mounted) {
          selectedPrinter = await showDialog<Printer>(
            context: context,
            barrierDismissible: false,
            builder: (context) => _PrinterSelectionDialog(
              printers: printers,
              initialPrinterUrl: lastPrinterUrl,
            ),
          );
        }
      }

      if (selectedPrinter == null) return; // user cancelled

      await prefs.setString(_printerKey, selectedPrinter.url);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Sending $fileName to ${selectedPrinter.name}...')),
        );
      }
      
      final result = await Printing.directPrintPdf(
        printer: selectedPrinter,
        onLayout: (format) => bytes,
        name: fileName,
      );

      if (context.mounted) {
        if (result) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Print job sent successfully!'), backgroundColor: Colors.green),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Print job failed or was cancelled.'), backgroundColor: Colors.red),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        // Pop the loading dialog if it's still showing
        try {
          Navigator.of(context).pop(); 
        } catch (_) {}
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Print error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }
}

class _PrinterSelectionDialog extends StatefulWidget {
  final List<Printer> printers;
  final String? initialPrinterUrl;

  const _PrinterSelectionDialog({required this.printers, this.initialPrinterUrl});

  @override
  State<_PrinterSelectionDialog> createState() => _PrinterSelectionDialogState();
}

class _PrinterSelectionDialogState extends State<_PrinterSelectionDialog> {
  Printer? _selected;

  @override
  void initState() {
    super.initState();
    if (widget.initialPrinterUrl != null) {
      try {
        _selected = widget.printers.firstWhere((p) => p.url == widget.initialPrinterUrl);
      } catch (_) {}
    }
    _selected ??= widget.printers.first;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Select Printer'),
      content: DropdownButton<Printer>(
        value: _selected,
        isExpanded: true,
        items: widget.printers.map((p) => DropdownMenuItem(
          value: p,
          child: Text('${p.name} ${p.isDefault ? "(Default)" : ""}'),
        )).toList(),
        onChanged: (val) {
          if (val != null) setState(() => _selected = val);
        },
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(_selected),
          child: const Text('Print'),
        ),
      ],
    );
  }
}
