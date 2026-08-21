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
    // Return empty state or throw exception
    throw Exception('Company settings not found');
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
