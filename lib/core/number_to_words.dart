class NumberToWords {
  static const List<String> _units = [
    '', 'One', 'Two', 'Three', 'Four', 'Five', 'Six', 'Seven', 'Eight', 'Nine',
    'Ten', 'Eleven', 'Twelve', 'Thirteen', 'Fourteen', 'Fifteen', 'Sixteen',
    'Seventeen', 'Eighteen', 'Nineteen'
  ];

  static const List<String> _tens = [
    '', '', 'Twenty', 'Thirty', 'Forty', 'Fifty', 'Sixty', 'Seventy', 'Eighty', 'Ninety'
  ];

  static String convert(double amount) {
    if (amount == 0) return 'Zero Only';
    
    int rupees = amount.truncate();
    int paise = ((amount - rupees) * 100).round();

    String result = '';
    if (rupees > 0) {
      result = '${_convertWholeNumber(rupees)} Rupees';
    }
    
    if (paise > 0) {
      if (result.isNotEmpty) {
        result += ' and ';
      }
      result += '${_convertWholeNumber(paise)} Paise';
    }
    
    return '$result Only';
  }

  static String _convertWholeNumber(int number) {
    if (number == 0) return '';

    if (number < 20) {
      return _units[number];
    }

    if (number < 100) {
      return _tens[number ~/ 10] + ((number % 10 != 0) ? ' ${_units[number % 10]}' : '');
    }

    if (number < 1000) {
      return '${_units[number ~/ 100]} Hundred${(number % 100 != 0) ? ' ${_convertWholeNumber(number % 100)}' : ''}';
    }

    if (number < 100000) {
      return '${_convertWholeNumber(number ~/ 1000)} Thousand${(number % 1000 != 0) ? ' ${_convertWholeNumber(number % 1000)}' : ''}';
    }

    if (number < 10000000) {
      return '${_convertWholeNumber(number ~/ 100000)} Lakh${(number % 100000 != 0) ? ' ${_convertWholeNumber(number % 100000)}' : ''}';
    }

    return '${_convertWholeNumber(number ~/ 10000000)} Crore${(number % 10000000 != 0) ? ' ${_convertWholeNumber(number % 10000000)}' : ''}';
  }
}
