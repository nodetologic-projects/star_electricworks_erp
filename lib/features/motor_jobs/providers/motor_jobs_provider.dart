import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:starelectricerp/data/database.dart';
import 'package:starelectricerp/data/repositories/motor_jobs_repository.dart';

final motorJobsStreamProvider = StreamProvider<List<MotorJob>>((ref) {
  return ref.watch(motorJobsRepositoryProvider).watchAllMotorJobs();
});
class MotorJobsSearchQuery extends Notifier<String> {
  @override
  String build() => '';

  void updateQuery(String query) {
    state = query;
  }
}

final motorJobsSearchQueryProvider = NotifierProvider<MotorJobsSearchQuery, String>(MotorJobsSearchQuery.new);

final filteredMotorJobsProvider = StreamProvider<List<Map<String, dynamic>>>((ref) {
  final searchQuery = ref.watch(motorJobsSearchQueryProvider);
  final repo = ref.watch(motorJobsRepositoryProvider);
  
  print('PROVIDER: Calling watchFilteredMotorJobs');
  return repo.watchFilteredMotorJobs(query: searchQuery).map((event) {
    print('PROVIDER: Emitted data with ${event.length} items');
    return event;
  }).handleError((e) {
    print('PROVIDER: Error: $e');
    throw e;
  });
});

final motorJobAutoNumberProvider = FutureProvider.autoDispose<String>((ref) async {
  final repo = ref.watch(motorJobsRepositoryProvider);
  final jobs = await repo.getAllMotorJobs();
  if (jobs.isEmpty) return 'JOB-0001';
  
  // Find highest number
  int maxNum = 0;
  for (var job in jobs) {
    final parts = job.jobNo.split('-');
    if (parts.length == 2) {
      final num = int.tryParse(parts[1]) ?? 0;
      if (num > maxNum) maxNum = num;
    }
  }
  
  final nextNum = maxNum + 1;
  return 'JOB-${nextNum.toString().padLeft(4, '0')}';
});
