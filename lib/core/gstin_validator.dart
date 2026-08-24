class GstinValidator {
  static const String _charset = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  // Prompt says: "1 letter ('Z' by default)". So we can just allow [A-Z] for the 14th character to be safe, but pattern technically expects Z.
  static final RegExp _loosePattern = RegExp(r'^[0-9]{2}[A-Z]{5}[0-9]{4}[A-Z]{1}[1-9A-Z]{1}[A-Z0-9]{1}[0-9A-Z]{1}$', caseSensitive: false);

  static String? validateStructure(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    
    final gstin = value.trim().toUpperCase();
    
    if (gstin.length != 15) {
      return 'GSTIN must be exactly 15 characters.';
    }

    if (!_loosePattern.hasMatch(gstin)) {
      return 'This doesn\'t look like a valid GSTIN — please double-check.';
    }
    
    // Check state code (01 - 38)
    final stateCodeStr = gstin.substring(0, 2);
    final stateCode = int.tryParse(stateCodeStr);
    if (stateCode == null || stateCode < 1 || stateCode > 38) {
      return 'This doesn\'t look like a valid GSTIN (invalid state code).';
    }

    // Check checksum
    if (!_verifyChecksum(gstin)) {
      return 'This GSTIN doesn\'t pass our format check — please verify it\'s correct.';
    }

    return null; // Valid
  }

  static bool _verifyChecksum(String gstin) {
    if (gstin.length != 15) return false;

    int sum = 0;
    for (int i = 0; i < 14; i++) {
      int charValue = _charset.indexOf(gstin[i]);
      if (charValue == -1) return false;

      int factor = (i % 2 == 0) ? 1 : 2;
      int product = charValue * factor;
      int quotient = product ~/ 36;
      int remainder = product % 36;
      
      sum += quotient + remainder;
    }

    int checkValue = (36 - (sum % 36)) % 36;
    String expectedCheckChar = _charset[checkValue];
    
    return expectedCheckChar == gstin[14];
  }
}
