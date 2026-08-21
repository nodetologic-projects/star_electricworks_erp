import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:starelectricerp/core/widgets/app_button.dart';
import 'package:starelectricerp/core/widgets/app_data_table.dart';
import 'package:starelectricerp/core/widgets/app_layout.dart';
import 'package:starelectricerp/core/widgets/status_badge.dart';
import 'package:starelectricerp/data/tables/enums.dart';
import 'package:starelectricerp/features/motor_jobs/providers/motor_jobs_provider.dart';

class MotorJobsListScreen extends ConsumerWidget {
  const MotorJobsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final jobsAsync = ref.watch(filteredMotorJobsProvider);
    final dateFormatter = DateFormat('dd MMM yyyy');

    return AppLayout(
      currentRoute: '/jobs',
      appBar: AppBar(title: const Text('Motor Jobs')),
      child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Motor Jobs',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      AppButton(
                        label: '+ New Job',
                        onPressed: () => context.push('/jobs/new'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    child: jobsAsync.when(
                      data: (jobs) {
                        return AppDataTable<Map<String, dynamic>>(
                          columns: const [
                            'Job No',
                            'Customer',
                            'Motor Description',
                            'Status',
                            'Date Received'
                          ],
                          data: jobs,
                          searchHint: 'Search by Customer or Job No...',
                          emptyMessage: 'No motor jobs found. Click "+ New Job" to get started.',
                          onSearchChanged: (val) {
                            ref.read(motorJobsSearchQueryProvider.notifier).updateQuery(val);
                          },
                          buildRow: (job) {
                            final statusEnum = job['status'] as MotorJobStatus;
                            StatusBadgeType badgeType;
                            switch (statusEnum) {
                              case MotorJobStatus.received:
                                badgeType = StatusBadgeType.received;
                                break;
                              case MotorJobStatus.inProgress:
                                badgeType = StatusBadgeType.inProgress;
                                break;
                              case MotorJobStatus.rewound:
                                badgeType = StatusBadgeType.rewound;
                                break;
                              case MotorJobStatus.dispatched:
                                badgeType = StatusBadgeType.dispatched;
                                break;
                            }

                            return [
                              InkWell(
                                onTap: () => context.push('/jobs/${job['id']}'),
                                child: Text(
                                  job['jobNo'],
                                  style: const TextStyle(
                                    color: Colors.blue,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                              Text(job['customerName']),
                              Text(job['motorDescription']),
                              StatusBadge(type: badgeType),
                              Text(dateFormatter.format(job['dateReceived'] as DateTime)),
                            ];
                          },
                        );
                      },
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (err, stack) => Center(child: Text('Error: $err')),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
