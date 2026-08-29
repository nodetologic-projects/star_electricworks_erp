import 'dart:convert';
import 'package:crypto/crypto.dart';

void main(List<String> args) {
  if (args.isEmpty) {
    print('Usage: dart generate_license.dart <GSTIN>');
    return;
  }

  final gstin = args.first.trim().toUpperCase();
  if (gstin.isEmpty) {
    print('Error: GSTIN cannot be empty.');
    return;
  }

  final secretKey = r'Kj9#vL2!mQ8$pX5@cT1*fW4^bR7&yN0';
  final hash = sha256.convert(utf8.encode('$gstin$secretKey')).toString().toUpperCase();
  final expectedCode = '${hash.substring(0, 4)}-${hash.substring(4, 8)}-${hash.substring(8, 12)}';

  print('====================================');
  print('GSTIN            : $gstin');
  print('REGISTRATION CODE: $expectedCode');
  print('====================================');
}
