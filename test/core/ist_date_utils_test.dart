import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/services.dart';
import 'package:starelectricerp/core/ist_date_utils.dart';
import 'package:starelectricerp/core/widgets/app_date_field.dart';

void main() {
  group('IstDateUtils', () {
    test('Strict validation for real dates', () {
      expect(IstDateUtils.parse('29/10/2026'), isNotNull);
      expect(IstDateUtils.parse('29/02/2024'), isNotNull); // Leap year 2024
      expect(IstDateUtils.parse('29/02/2025'), isNull); // Non-leap year 2025
      expect(IstDateUtils.parse('31/02/2026'), isNull); // February never has 31 days
      expect(IstDateUtils.parse('31/04/2026'), isNull); // April has 30 days
      expect(IstDateUtils.parse('31/06/2026'), isNull); // June has 30 days
      expect(IstDateUtils.parse('31/09/2026'), isNull); // Sept has 30 days
      expect(IstDateUtils.parse('31/11/2026'), isNull); // Nov has 30 days
      expect(IstDateUtils.parse('31/12/2026'), isNotNull);
      expect(IstDateUtils.parse('00/01/2026'), isNull);
      expect(IstDateUtils.parse('15/13/2026'), isNull);
      expect(IstDateUtils.parse('invalid'), isNull);
      expect(IstDateUtils.parse('15/08'), isNull);
    });

    test('Normalization to midnight IST', () {
      final dt = DateTime(2026, 10, 29, 14, 45, 12);
      final normalized = IstDateUtils.toMidnightIst(dt);
      expect(normalized.year, 2026);
      expect(normalized.month, 10);
      expect(normalized.day, 29);
      expect(normalized.hour, 0);
      expect(normalized.minute, 0);
      expect(normalized.second, 0);
    });

    test('Formatting dd/MM/yyyy', () {
      final dt = DateTime(2026, 5, 4);
      expect(IstDateUtils.format(dt), '04/05/2026');
      expect(IstDateUtils.format(null), '');
    });
  });

  group('DateInputFormatter', () {
    final formatter = DateInputFormatter();

    TextEditingValue apply(String oldVal, String newVal) {
      return formatter.formatEditUpdate(
        TextEditingValue(text: oldVal, selection: TextSelection.collapsed(offset: oldVal.length)),
        TextEditingValue(text: newVal, selection: TextSelection.collapsed(offset: newVal.length)),
      );
    }

    test('Auto-inserts slashes as digits are typed', () {
      var res = apply('', '2');
      expect(res.text, '2');

      res = apply('2', '29');
      expect(res.text, '29/');

      res = apply('29/', '29/1');
      expect(res.text, '29/1');

      res = apply('29/1', '29/10');
      expect(res.text, '29/10/');

      res = apply('29/10/', '29/10/2');
      expect(res.text, '29/10/2');

      res = apply('29/10/202', '29/10/2026');
      expect(res.text, '29/10/2026');
    });

    test('Handles pasting unformatted digits or dashes', () {
      final res = apply('', '29102026');
      expect(res.text, '29/10/2026');
    });

    test('Handles backspacing past slashes gracefully', () {
      final res = apply('29/', '29');
      expect(res.text, '2');
    });
  });
}
