import 'dart:io';
import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pw;

class PdfFontHelper {
  static pw.ThemeData? _cachedTheme;

  static Future<ByteData> _loadAsset(String path) async {
    try {
      return await rootBundle.load(path);
    } catch (_) {
      final file = File(path);
      if (file.existsSync()) {
        final bytes = file.readAsBytesSync();
        return ByteData.view(bytes.buffer);
      }
      rethrow;
    }
  }

  /// Loads Roboto (Regular, Medium, Bold, Italic) as base fonts
  /// and Noto Sans Gujarati & Devanagari as offline fallbacks.
  static Future<pw.ThemeData> loadTheme() async {
    if (_cachedTheme != null) return _cachedTheme!;

    final robotoRegular = pw.Font.ttf(await _loadAsset('assets/fonts/Roboto-Regular.ttf'));
    final robotoBold = pw.Font.ttf(await _loadAsset('assets/fonts/Roboto-Bold.ttf'));
    final robotoItalic = pw.Font.ttf(await _loadAsset('assets/fonts/Roboto-Italic.ttf'));
    final robotoMedium = pw.Font.ttf(await _loadAsset('assets/fonts/Roboto-Medium.ttf'));

    final notoSansGujarati = pw.Font.ttf(await _loadAsset('assets/fonts/NotoSansGujarati-Regular.ttf'));
    final notoSansGujaratiBold = pw.Font.ttf(await _loadAsset('assets/fonts/NotoSansGujarati-Bold.ttf'));
    final notoSansDevanagari = pw.Font.ttf(await _loadAsset('assets/fonts/NotoSansDevanagari-Regular.ttf'));
    final notoSansDevanagariBold = pw.Font.ttf(await _loadAsset('assets/fonts/NotoSansDevanagari-Bold.ttf'));

    _cachedTheme = pw.ThemeData.withFont(
      base: robotoRegular,
      bold: robotoBold,
      italic: robotoItalic,
      boldItalic: robotoMedium,
      fontFallback: [
        notoSansGujarati,
        notoSansGujaratiBold,
        notoSansDevanagari,
        notoSansDevanagariBold,
      ],
    );

    return _cachedTheme!;
  }
}
