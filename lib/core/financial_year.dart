class FinancialYear {
  static const int epochYear = 2024;

  /// Returns the starting year of the financial year for a given date.
  /// (e.g., Feb 2025 -> 2024. May 2024 -> 2024).
  static int getFinancialStartYear(DateTime date) {
    if (date.month < 4) {
      return date.year - 1;
    }
    return date.year;
  }

  /// Returns the base letter label for a given date based on the epoch.
  static String getLabelForDate(DateTime date) {
    final startYear = getFinancialStartYear(date);
    final index = startYear - epochYear;
    return getLabelForIndex(index);
  }

  /// Converts a 0-based index to spreadsheet-style base-26 (0=A, 25=Z, 26=AA).
  static String getLabelForIndex(int index) {
    if (index < 0) {
      // Fallback for dates before the epoch
      return 'PRE${index.abs()}';
    }
    String result = '';
    int temp = index;
    while (temp >= 0) {
      result = String.fromCharCode((temp % 26) + 65) + result;
      temp = (temp ~/ 26) - 1;
    }
    return result;
  }

  /// Calculates the final label handling the > 5000 rollover rule.
  /// If number <= 5000, returns baseLabel (e.g., 'A').
  /// If number > 5000, appends a rollover letter sequence (e.g., 'AA', 'AB').
  static String getRolloverLabel(String baseLabel, int number) {
    if (number <= 5000) return baseLabel;
    
    // Determine how many times we've exceeded 5000.
    // 5001..10000 -> rollover 1 (append 'A')
    // 10001..15000 -> rollover 2 (append 'B')
    int rolloverIndex = (number - 1) ~/ 5000;
    return baseLabel + getLabelForIndex(rolloverIndex - 1);
  }
}
