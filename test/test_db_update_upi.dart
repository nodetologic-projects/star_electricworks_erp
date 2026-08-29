import 'package:starelectricerp/data/database.dart';
import 'package:starelectricerp/data/tables/company_settings.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:drift/native.dart';
import 'package:drift/drift.dart' as drift;
import 'dart:io';

void main() {
  testWidgets('Update UPI ID in DB', (WidgetTester tester) async {
    final dbFile = File('/Users/nodetolearn/Library/Containers/com.nodetologic.starelectricerp.starElectricErp/Data/Documents/starelectricerp.sqlite');
    final db = AppDatabase(NativeDatabase(dbFile));
    
    await db.update(db.companySettings).write(
      CompanySettingsCompanion(
        upiId: drift.Value('starworks@ybl'),
        companyName: drift.Value('Star Electric Works'),
        address: drift.Value('123 Main St'),
        phone: drift.Value('9999999999'),
        email: drift.Value('contact@starelectric.com'),
        gstin: drift.Value('22AAAAA0000A1Z5'),
        bankName: drift.Value('HDFC Bank'),
        bankAccountNo: drift.Value('50100012345678'),
        bankIfsc: drift.Value('HDFC0001234'),
      ),
    );
    
    final settings = await db.select(db.companySettings).get();
    print('Updated DB upiId to: "${settings.first.upiId}"');
    
    await db.close();
  });
}
