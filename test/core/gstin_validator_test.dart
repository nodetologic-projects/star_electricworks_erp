import 'package:flutter_test/flutter_test.dart';
import 'package:starelectricerp/core/gstin_validator.dart';

void main() {
  group('GstinValidator', () {
    test('Returns null for empty strings (optional field logic handled elsewhere)', () {
      expect(GstinValidator.validateStructure(''), isNull);
      expect(GstinValidator.validateStructure(null), isNull);
    });

    test('Validates correctly against known valid GSTINs', () {
      expect(GstinValidator.validateStructure('29GGGGG1314R9ZA'), isNull);
      expect(GstinValidator.validateStructure('22AAAAA0000A1ZC'), isNull);
    });

    test('Fails on incorrect length', () {
      expect(GstinValidator.validateStructure('22AAAAA0000A1Z'), 'GSTIN must be exactly 15 characters.');
      expect(GstinValidator.validateStructure('22AAAAA0000A1Z55'), 'GSTIN must be exactly 15 characters.');
    });

    test('Fails on invalid state code', () {
      expect(GstinValidator.validateStructure('99GGGGG1314R9ZA'), 'This doesn\'t look like a valid GSTIN (invalid state code).');
      expect(GstinValidator.validateStructure('00GGGGG1314R9ZA'), 'This doesn\'t look like a valid GSTIN (invalid state code).');
    });

    test('Fails on incorrect checksum', () {
      expect(GstinValidator.validateStructure('29GGGGG1314R9ZB'), 'This GSTIN doesn\'t pass our format check — please verify it\'s correct.');
    });
    
    test('Fails on bad structure format', () {
      expect(GstinValidator.validateStructure('29123451314R9ZA'), 'This doesn\'t look like a valid GSTIN — please double-check.');
    });
  });
}
