import 'package:flutter_test/flutter_test.dart';
import 'package:starelectricerp/core/number_to_words.dart';

void main() {
  group('NumberToWords', () {
    test('Zero', () {
      expect(NumberToWords.convert(0), 'Zero Only');
    });

    test('Single digits', () {
      expect(NumberToWords.convert(5), 'Five Rupees Only');
    });

    test('Teens', () {
      expect(NumberToWords.convert(14), 'Fourteen Rupees Only');
    });

    test('Tens', () {
      expect(NumberToWords.convert(42), 'Forty Two Rupees Only');
    });

    test('Hundreds', () {
      expect(NumberToWords.convert(536), 'Five Hundred Thirty Six Rupees Only');
    });

    test('Thousands', () {
      expect(NumberToWords.convert(69536), 'Sixty Nine Thousand Five Hundred Thirty Six Rupees Only');
    });

    test('Lakhs', () {
      expect(NumberToWords.convert(1234567), 'Twelve Lakh Thirty Four Thousand Five Hundred Sixty Seven Rupees Only');
    });

    test('Crores', () {
      expect(NumberToWords.convert(123456789), 'Twelve Crore Thirty Four Lakh Fifty Six Thousand Seven Hundred Eighty Nine Rupees Only');
    });

    test('With Paise', () {
      expect(NumberToWords.convert(10.50), 'Ten Rupees and Fifty Paise Only');
      expect(NumberToWords.convert(0.75), 'Seventy Five Paise Only');
    });
  });
}
