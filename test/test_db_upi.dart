import 'package:starelectricerp/data/database.dart';
import 'package:starelectricerp/data/tables/company_settings.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'dart:io';

void main() {
  testWidgets('Check UPI ID in DB', (WidgetTester tester) async {
    final dbFile = File('/Users/nodetolearn/Library/Containers/com.nodetologic.starelectricerp.starElectricErp/Data/Documents/starelectricerp.sqlite');
    if (!dbFile.existsSync()) {
      print('DB file not found!');
      return;
    }
    
    final db = AppDatabase(NativeDatabase(dbFile));
    final settings = await db.select(db.companySettings).get();
    
    if (settings.isEmpty) {
      print('No company settings found!');
    } else {
      for (var s in settings) {
        print('DB upiId: "${s.upiId}"');
      }
    }
    await db.close();
  });
}
