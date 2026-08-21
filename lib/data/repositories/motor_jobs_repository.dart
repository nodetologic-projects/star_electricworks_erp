import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart';
import 'package:starelectricerp/data/database.dart';
import 'package:starelectricerp/data/tables/enums.dart';

final motorJobsRepositoryProvider = Provider((ref) {
  return MotorJobsRepository(ref.watch(databaseProvider));
});

class MotorJobsRepository {
  final AppDatabase _db;
  MotorJobsRepository(this._db);

  Future<List<MotorJob>> getAllMotorJobs() => _db.select(_db.motorJobs).get();
  
  Stream<List<MotorJob>> watchAllMotorJobs() => _db.select(_db.motorJobs).watch();

  Stream<List<Map<String, dynamic>>> watchFilteredMotorJobs({String query = ''}) {
    var statement = _db.select(_db.motorJobs).join([
      innerJoin(_db.customers, _db.customers.id.equalsExp(_db.motorJobs.customerId)),
    ]);
    
    if (query.isNotEmpty) {
      statement.where(_db.motorJobs.jobNo.like('%$query%') | _db.customers.name.like('%$query%'));
    }
    
    statement.orderBy([OrderingTerm(expression: _db.motorJobs.createdAt, mode: OrderingMode.desc)]);
    
    return statement.watch().map((rows) {
      return rows.map((row) {
        final job = row.readTable(_db.motorJobs);
        final customer = row.readTable(_db.customers);
        return {
          'id': job.id,
          'jobNo': job.jobNo,
          'customerName': customer.name,
          'motorDescription': job.motorDescription,
          'status': job.status,
          'dateReceived': job.dateReceived,
        };
      }).toList();
    });
  }

  Future<MotorJob> getMotorJobById(int id) {
    return (_db.select(_db.motorJobs)..where((t) => t.id.equals(id))).getSingle();
  }

  Future<int> insertMotorJob(MotorJobsCompanion job) {
    return _db.into(_db.motorJobs).insert(job);
  }

  Future<bool> updateMotorJob(MotorJobsCompanion job) {
    return _db.update(_db.motorJobs).replace(job);
  }

  Future<int> updateMotorJobStatus(int id, MotorJobStatus status) {
    return (_db.update(_db.motorJobs)..where((t) => t.id.equals(id)))
        .write(MotorJobsCompanion(status: Value(status)));
  }

  Future<int> deleteMotorJob(int id) {
    return (_db.delete(_db.motorJobs)..where((t) => t.id.equals(id))).go();
  }
}
