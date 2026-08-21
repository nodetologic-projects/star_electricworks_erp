import 'dart:io';
import 'package:path/path.dart' as p;

class DscSigner {
  /// Signs a PDF using the bundled C# helper on Windows.
  /// Returns a status code where 0 is success.
  static Future<int> signPdf({
    required String inputPdfPath,
    required String outputPdfPath,
    required String certPath,
    required String password,
  }) async {
    if (!Platform.isWindows) {
      return -1; // -1 indicates unsupported platform
    }

    try {
      // Locate the helper executable next to the app executable or in data directory
      final exeDir = p.dirname(Platform.resolvedExecutable);
      
      // In development, we might just look in the workspace root or flutter assets.
      // Assuming it's bundled in a "pdf_signer" directory in production
      // or directly executable during dev.
      final helperPath = p.join(exeDir, 'data', 'flutter_assets', 'pdf_signer', 'pdf_signer.exe');
      
      // Fallback for development run (assuming Cwd is the project root)
      final devHelperPath = p.join(Directory.current.path, 'windows', 'helpers', 'pdf_signer', 'bin', 'Release', 'net8.0', 'win-x64', 'publish', 'pdf_signer.exe');
      
      final String targetExe = File(helperPath).existsSync() ? helperPath : devHelperPath;

      if (!File(targetExe).existsSync()) {
        return -2; // -2 indicates helper not found
      }

      final result = await Process.run(
        targetExe,
        ['file', inputPdfPath, outputPdfPath, certPath, password],
      );
      if (result.stderr.toString().isNotEmpty) {
      }

      return result.exitCode;
    } catch (e) {
      return -3; // -3 indicates unhandled exception
    }
  }

  /// Signs a PDF using a PKCS#11 hardware token (e.g., USB Token)
  static Future<int> signPdfToken({
    required String inputPdfPath,
    required String outputPdfPath,
    required String dllPath,
    required String pin,
  }) async {
    if (!Platform.isWindows) {
      return -1;
    }

    try {
      final exeDir = p.dirname(Platform.resolvedExecutable);
      final helperPath = p.join(exeDir, 'data', 'flutter_assets', 'pdf_signer', 'pdf_signer.exe');
      final devHelperPath = p.join(Directory.current.path, 'windows', 'helpers', 'pdf_signer', 'bin', 'Release', 'net8.0', 'win-x64', 'publish', 'pdf_signer.exe');
      
      final String targetExe = File(helperPath).existsSync() ? helperPath : devHelperPath;

      if (!File(targetExe).existsSync()) {
        return -2;
      }

      final result = await Process.run(
        targetExe,
        ['token', inputPdfPath, outputPdfPath, dllPath, pin],
      );
      if (result.stderr.toString().isNotEmpty) {
      }

      return result.exitCode;
    } catch (e) {
      return -3;
    }
  }
}
