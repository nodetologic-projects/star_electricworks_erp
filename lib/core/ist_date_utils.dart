import 'package:intl/intl.dart';

/// Utilities for normalizing, formatting, and strictly validating dates in Indian Standard Time (IST, UTC+05:30).
class IstDateUtils {
  static const Duration istOffset = Duration(hours: 5, minutes: 30);
  static final DateFormat _displayFormat = DateFormat('dd/MM/yyyy');

  /// Normalizes any DateTime to midnight (00:00:00.000) of its calendar day in IST.
  /// If [dt] is already a date-only object with 00:00:00, it extracts its calendar date.
  static DateTime toMidnightIst(DateTime dt) {
    if (dt.isUtc) {
      final ist = dt.add(istOffset);
      return DateTime(ist.year, ist.month, ist.day);
    } else {
      // Local DateTime: convert to UTC, then apply IST offset to get the IST calendar day
      final utc = dt.toUtc();
      final ist = utc.add(istOffset);
      return DateTime(ist.year, ist.month, ist.day);
    }
  }

  /// Returns today's date normalized to midnight in IST.
  static DateTime nowIst() {
    return toMidnightIst(DateTime.now());
  }

  /// Formats date as dd/MM/yyyy.
  static String format(DateTime? dt) {
    if (dt == null) return '';
    return _displayFormat.format(dt);
  }

  /// Parses dd/MM/yyyy string into an IST midnight DateTime.
  /// Validates real calendar dates strictly (rejects 31/02, 31/04, 29/02 in non-leap years, etc.).
  /// Returns null if invalid or incomplete.
  static DateTime? parse(String? input) {
    if (input == null) return null;
    final clean = input.trim();
    final parts = clean.split('/');
    if (parts.length != 3) return null;

    final d = int.tryParse(parts[0]);
    final m = int.tryParse(parts[1]);
    final y = int.tryParse(parts[2]);
    if (d == null || m == null || y == null) return null;
    if (parts[0].length != 2 || parts[1].length != 2 || parts[2].length != 4) {
      return null;
    }
    if (y < 1900 || y > 2100 || m < 1 || m > 12 || d < 1 || d > 31) {
      return null;
    }

    final dt = DateTime(y, m, d);
    // Strict calendar validation: DateTime auto-rolls invalid dates, so verify exact match
    if (dt.year != y || dt.month != m || dt.day != d) {
      return null;
    }
    return dt;
  }

  /// Checks if two DateTimes represent the exact same calendar day.
  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
