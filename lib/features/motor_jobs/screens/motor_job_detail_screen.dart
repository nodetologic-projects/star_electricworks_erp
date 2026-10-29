import 'package:starelectricerp/core/widgets/parsed_rich_text.dart';
import 'package:starelectricerp/data/repositories/invoices_repository.dart';
import 'package:starelectricerp/features/billing/providers/invoice_detail_provider.dart';
import 'package:starelectricerp/features/billing/pdf/invoice_pdf.dart';
import 'package:starelectricerp/core/services/direct_print_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:starelectricerp/core/theme/app_theme.dart';
import 'package:starelectricerp/core/widgets/app_button.dart';
import 'package:starelectricerp/core/widgets/app_layout.dart';
import 'package:starelectricerp/core/widgets/app_text_field.dart';
import 'package:starelectricerp/core/widgets/status_badge.dart';
import 'package:starelectricerp/data/tables/enums.dart';
import 'package:starelectricerp/data/database.dart';
import 'package:starelectricerp/data/repositories/motor_jobs_repository.dart';
import 'package:starelectricerp/features/customers/providers/customers_provider.dart';

final motorJobDetailProvider = FutureProvider.autoDispose.family<MotorJob, int>((ref, id) async {
  final repo = ref.watch(motorJobsRepositoryProvider);
  return repo.getMotorJobById(id);
});

class MotorJobDetailScreen extends ConsumerStatefulWidget {
  final int jobId;
  const MotorJobDetailScreen({super.key, required this.jobId});

  @override
  ConsumerState<MotorJobDetailScreen> createState() => _MotorJobDetailScreenState();
}

class _MotorJobDetailScreenState extends ConsumerState<MotorJobDetailScreen> {
  final _serviceChargeController = TextEditingController();
  bool _isAdvancing = false;

  @override
  void dispose() {
    _serviceChargeController.dispose();
    super.dispose();
  }

  Future<void> _advanceStatus(MotorJobStatus currentStatus) async {
    setState(() => _isAdvancing = true);
    try {
      MotorJobStatus nextStatus;
      switch (currentStatus) {
        case MotorJobStatus.received:
          nextStatus = MotorJobStatus.inProgress;
          break;
        case MotorJobStatus.inProgress:
          nextStatus = MotorJobStatus.rewound;
          break;
        case MotorJobStatus.rewound:
          // Check for delivery challan
          final repo = ref.read(invoicesRepositoryProvider);
          final challans = await repo.getInvoicesByJobId(widget.jobId);
          final hasChallan = challans.any((inv) => inv.invoiceType == InvoiceType.deliveryChallan);
          if (!hasChallan) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Cannot dispatch: Please generate a Delivery Challan first.')),
              );
            }
            return;
          }
          nextStatus = MotorJobStatus.dispatched;
          break;
        case MotorJobStatus.dispatched:
          return;
      }

      await ref.read(motorJobsRepositoryProvider).updateMotorJobStatus(widget.jobId, nextStatus);
      ref.invalidate(motorJobDetailProvider(widget.jobId));
    } finally {
      if (mounted) setState(() => _isAdvancing = false);
    }
  }


  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 4),
          ParsedRichText(
            text: value,
            style: const TextStyle(fontSize: 15),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final jobAsync = ref.watch(motorJobDetailProvider(widget.jobId));
    final customersAsync = ref.watch(customersStreamProvider);
    final dateFormatter = DateFormat('dd MMM yyyy, hh:mm a');

    return AppLayout(
      currentRoute: '/jobs',
      child: jobAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (job) {
          final customer = customersAsync.value?.firstWhere(
            (c) => c.id == job.customerId,
          );

          StatusBadgeType badgeType;
          switch (job.status) {
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

          return SingleChildScrollView(

            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: () => context.go('/jobs'),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Job ${job.jobNo}',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                    const SizedBox(width: 16),
                    StatusBadge(type: badgeType),
                    const Spacer(),
                    OutlinedButton.icon(
                      icon: const Icon(Icons.edit, size: 16),
                      label: const Text('Edit Job'),
                      onPressed: () => context.push('/jobs/${widget.jobId}/edit'),
                    ),
                    const SizedBox(width: 8),
                    if (job.status == MotorJobStatus.received || job.status == MotorJobStatus.inProgress)
                      AppButton(
                        label: job.status == MotorJobStatus.received ? 'Start Work' : 'Mark Rewound',
                        onPressed: () => _advanceStatus(job.status),
                        isLoading: _isAdvancing,
                      ),
                  ],
                ),
                const SizedBox(height: 32),
                
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Details Column
                    Expanded(
                      flex: 2,
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildInfoRow('Customer', customer?.name ?? 'Loading...'),
                            _buildInfoRow('Motor Description', job.motorDescription),
                            _buildInfoRow('Motor Make', job.motorMake ?? 'N/A'),
                            _buildInfoRow('HP', job.hp?.toString() ?? 'N/A'),
                            _buildInfoRow('Phase', job.phase?.name.toUpperCase() ?? 'N/A'),
                            _buildInfoRow('Date Received', dateFormatter.format(job.dateReceived)),
                            _buildInfoRow('Job Description', job.jobDescription),
                            if (job.sacCode != null && job.sacCode!.isNotEmpty)
                              _buildInfoRow('SAC Code (Repair)', job.sacCode!),
                            if (job.hsnCode != null && job.hsnCode!.isNotEmpty)
                              _buildInfoRow('HSN Code (Motor Goods)', job.hsnCode!),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 24),
                    // Actions Column
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          if (job.status == MotorJobStatus.rewound) ...[
                            Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade200),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Service Invoice', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                                  const SizedBox(height: 16),
                                  AppTextField(
                                    label: 'Service Charge (₹)',
                                    controller: _serviceChargeController,
                                    keyboardType: TextInputType.number,
                                  ),
                                  const SizedBox(height: 16),
                                  SizedBox(
                                    width: double.infinity,
                                    child: AppButton(
                                      label: 'Generate Service Invoice',
                                      onPressed: () {
                                        context.push('/invoices/new', extra: {
                                          'type': InvoiceType.serviceTaxInvoice,
                                          'jobId': job.id,
                                          'customerId': job.customerId,
                                        });
                                      },
                                    ),
                                  ),
                                  const SizedBox(height: 32),
                                  const Text('Delivery', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                                  const SizedBox(height: 16),
                                  SizedBox(
                                    width: double.infinity,
                                    child: AppButton(
                                      label: 'Generate Delivery Challan',
                                      variant: AppButtonVariant.primary,
                                      onPressed: () {
                                        context.push('/invoices/new', extra: {
                                          'type': InvoiceType.deliveryChallan,
                                          'jobId': job.id,
                                          'customerId': job.customerId,
                                        });
                                      },
                                      isLoading: _isAdvancing,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                          if (job.status == MotorJobStatus.dispatched) ...[
                            Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade200),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: const [
                                      Icon(Icons.check_circle, color: AppTheme.successGreen),
                                      SizedBox(width: 8),
                                      Expanded(child: Text('Job Dispatched', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16, color: AppTheme.successGreen))),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  SizedBox(
                                    width: double.infinity,
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: AppButton(
                                            label: 'View Delivery Challan',
                                            variant: AppButtonVariant.secondary,
                                            onPressed: () async {
                                              final repo = ref.read(invoicesRepositoryProvider);
                                              final challans = await repo.getInvoicesByJobId(job.id);
                                              final challan = challans.firstWhere(
                                                (inv) => inv.invoiceType == InvoiceType.deliveryChallan, 
                                                orElse: () => throw Exception('Challan not found')
                                              );
                                              if (context.mounted) {
                                                context.push('/invoices/${challan.id}');
                                              }
                                            },
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: AppButton(
                                            label: 'Direct Print Challan',
                                            variant: AppButtonVariant.primary,
                                            onPressed: () async {
                                              try {
                                                final repo = ref.read(invoicesRepositoryProvider);
                                                final challans = await repo.getInvoicesByJobId(job.id);
                                                final challan = challans.firstWhere(
                                                  (inv) => inv.invoiceType == InvoiceType.deliveryChallan, 
                                                );
                                                final invoiceDetail = await ref.read(invoiceDetailProvider(challan.id).future);
                                                if (context.mounted) {
                                                  DirectPrintService.printPdf(
                                                    context,
                                                    challan.invoiceNo,
                                                    fallbackGenerate: () => InvoicePdfGenerator.generate(
                                                      company: invoiceDetail.companySetting,
                                                      invoice: invoiceDetail.invoice,
                                                      items: invoiceDetail.items,
                                                      customer: invoiceDetail.customer,
                                                    ),
                                                  );
                                                }
                                              } catch (e) {
                                                if (context.mounted) {
                                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Could not print: $e'), backgroundColor: Colors.red));
                                                }
                                              }
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ]
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
