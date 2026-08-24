import 'package:intl/intl.dart';

class PdfDateFormatter {
  static final _pdfFormat = DateFormat('dd/MM/yyyy');

  static String formatDate(DateTime date) {
    return _pdfFormat.format(date);
  }
}
