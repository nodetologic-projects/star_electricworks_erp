import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:starelectricerp/data/database.dart';

final settingsRepositoryProvider = Provider((ref) {
  return SettingsRepository(ref.watch(databaseProvider));
});

class SettingsRepository {
  final AppDatabase _db;
  SettingsRepository(this._db);

  Future<CompanySetting> getSettings() async {
    final settings = await _db.select(_db.companySettings).get();
    if (settings.isNotEmpty) {
      return settings.first;
    }
    // Seed default settings if empty
    final defaultSettings = CompanySettingsCompanion.insert(
      companyName: 'Star Electric Works',
      address: '123 Default Address',
      phone: '+91 0000000000',
      email: 'info@starelectric.com',
      gstin: '24AAAAA0000A1Z5',
      bankName: 'Default Bank',
      bankAccountNo: '0000000000',
      bankIfsc: 'IFSC0000000',
    );
    await insertSettings(defaultSettings);
    final newSettings = await _db.select(_db.companySettings).get();
    return newSettings.first;
  }
  
  Stream<CompanySetting?> watchSettings() {
    return _db.select(_db.companySettings).watchSingleOrNull();
  }

  Future<bool> updateSettings(CompanySettingsCompanion settings) {
    return _db.update(_db.companySettings).replace(settings);
  }

  Future<int> insertSettings(CompanySettingsCompanion settings) {
    return _db.into(_db.companySettings).insert(settings);
  }
}
