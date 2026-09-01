import 'package:starelectricerp/features/customers/screens/customers_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:starelectricerp/data/tables/enums.dart';

import 'package:starelectricerp/features/support/screens/support_screen.dart';
import 'package:starelectricerp/features/settings/settings_screen.dart';
import 'package:starelectricerp/features/motor_jobs/screens/motor_jobs_list_screen.dart';
import 'package:starelectricerp/features/motor_jobs/screens/motor_job_form_screen.dart';
import 'package:starelectricerp/features/motor_jobs/screens/motor_job_detail_screen.dart';
import 'package:starelectricerp/features/copper_stock/screens/copper_stock_list_screen.dart';
import 'package:starelectricerp/features/purchases/screens/purchases_list_screen.dart';
import 'package:starelectricerp/features/purchases/screens/add_purchase_screen.dart';
import 'package:starelectricerp/features/copper_stock/screens/copper_stock_form_screen.dart';
import 'package:starelectricerp/features/dashboard/screens/dashboard_screen.dart';
import 'package:starelectricerp/features/billing/screens/invoices_list_screen.dart';
import 'package:starelectricerp/features/billing/screens/invoice_form_screen.dart';
import 'package:starelectricerp/features/billing/screens/invoice_detail_screen.dart';
import 'package:starelectricerp/features/reports/screens/reports_screen.dart';
import 'package:starelectricerp/features/attendance/screens/employee_list_screen.dart';
import 'package:starelectricerp/features/attendance/screens/daily_attendance_screen.dart';
import 'package:starelectricerp/features/attendance/screens/attendance_history_screen.dart';
import 'package:starelectricerp/features/cashbook/screens/cashbook_screen.dart';
import 'package:starelectricerp/features/customers/ledger/outstanding_summary_screen.dart';
import 'package:starelectricerp/features/customers/ledger/customer_ledger_screen.dart';
import 'package:starelectricerp/features/quotations/screens/quotations_list_screen.dart';
import 'package:starelectricerp/features/quotations/screens/quotation_form_screen.dart';
import 'package:starelectricerp/features/quotations/screens/quotation_detail_screen.dart';
import 'package:starelectricerp/features/auth/providers/auth_provider.dart';
import 'package:starelectricerp/features/auth/screens/lock_screen.dart';

// Placeholder Screens
class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/stock'); // Fallback to stock list
            }
          },
        ),
      ),
      body: Center(child: Text(title, style: Theme.of(context).textTheme.headlineMedium)),
    );
  }
}

Page<dynamic> _fadeTransitionPage(BuildContext context, GoRouterState state, Widget child) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
    transitionDuration: const Duration(milliseconds: 150),
  );
}

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/dashboard',
    redirect: (context, state) {
      if (!authState.isInitialized) {
        return null; // Wait for init
      }
      
      final isLockScreen = state.matchedLocation == '/lock';
      if (authState.isLocked) {
        if (!isLockScreen) return '/lock';
      } else {
        if (isLockScreen) return '/dashboard';
      }
      return null;
    },
    routes: [
      GoRoute(
        path: '/lock',
        pageBuilder: (context, state) => _fadeTransitionPage(context, state, const LockScreen()),
      ),
      GoRoute(
        path: '/jobs',
        pageBuilder: (context, state) => _fadeTransitionPage(context, state, const MotorJobsListScreen()),
      ),
      GoRoute(
        path: '/jobs/new',
        pageBuilder: (context, state) => _fadeTransitionPage(context, state, const MotorJobFormScreen()),
      ),
      GoRoute(
        path: '/jobs/:id',
        pageBuilder: (context, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
          return _fadeTransitionPage(context, state, MotorJobDetailScreen(jobId: id));
        },
      ),
      GoRoute(
        path: '/dashboard',
        pageBuilder: (context, state) => _fadeTransitionPage(context, state, const DashboardScreen()),
      ),
      GoRoute(
        path: '/invoices',
        pageBuilder: (context, state) => _fadeTransitionPage(context, state, const InvoicesListScreen()),
      ),
      GoRoute(
        path: '/invoices/new',
        pageBuilder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return _fadeTransitionPage(
            context, 
            state, 
            InvoiceFormScreen(
              prefillType: extra?['type'] as InvoiceType?,
              prefillJobId: extra?['jobId'] as int?,
              prefillCustomerId: extra?['customerId'] as int?,
              sourceQuotationId: extra?['sourceQuotationId'] as int?,
              prefillDescription: extra?['description'] as String?,
              prefillAmount: extra?['amount'] as double?,
            ),
          );
        },
      ),
      GoRoute(
        path: '/invoices/edit/:id',
        pageBuilder: (context, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
          return _fadeTransitionPage(
            context,
            state,
            InvoiceFormScreen(invoiceId: id),
          );
        },
      ),
      GoRoute(
        path: '/invoices/:id',
        pageBuilder: (context, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
          return _fadeTransitionPage(context, state, InvoiceDetailScreen(invoiceId: id));
        },
      ),
      GoRoute(
        path: '/stock',
        pageBuilder: (context, state) => _fadeTransitionPage(context, state, const CopperStockListScreen()),
      ),
      GoRoute(
        path: '/stock/new',
        pageBuilder: (context, state) => _fadeTransitionPage(context, state, const CopperStockFormScreen()),
      ),
      GoRoute(
        path: '/stock/:id',
        pageBuilder: (context, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
          return _fadeTransitionPage(context, state, CopperStockFormScreen(stockId: id));
        },
      ),
      GoRoute(
        path: '/customers',
        pageBuilder: (context, state) => _fadeTransitionPage(context, state, const CustomersListScreen()),
      ),
      GoRoute(
        path: '/attendance',
        pageBuilder: (context, state) => _fadeTransitionPage(context, state, const EmployeeListScreen()),
      ),
      GoRoute(
        path: '/attendance/daily',
        pageBuilder: (context, state) => _fadeTransitionPage(context, state, const DailyAttendanceScreen()),
      ),
      GoRoute(
        path: '/attendance/history',
        pageBuilder: (context, state) => _fadeTransitionPage(context, state, const AttendanceHistoryScreen()),
      ),
      GoRoute(
        path: '/cashbook',
        pageBuilder: (context, state) => _fadeTransitionPage(context, state, const CashbookScreen()),
      ),
      GoRoute(
        path: '/purchases',
        pageBuilder: (context, state) => _fadeTransitionPage(context, state, const PurchasesListScreen()),
      ),
      GoRoute(
        path: '/purchases/new',
        pageBuilder: (context, state) => _fadeTransitionPage(context, state, const AddPurchaseScreen()),
      ),
      GoRoute(
        path: '/purchases/edit/:id',
        pageBuilder: (context, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '');
          return _fadeTransitionPage(context, state, AddPurchaseScreen(purchaseId: id));
        },
      ),
      GoRoute(
        path: '/purchases',
        pageBuilder: (context, state) => _fadeTransitionPage(context, state, const PurchasesListScreen()),
      ),
      GoRoute(
        path: '/purchases/new',
        pageBuilder: (context, state) => _fadeTransitionPage(context, state, const AddPurchaseScreen()),
      ),
      GoRoute(
        path: '/',
        redirect: (context, state) => '/dashboard',
      ),
      GoRoute(
        path: '/reports',
        pageBuilder: (context, state) => _fadeTransitionPage(context, state, const ReportsScreen()),
      ),
      GoRoute(
        path: '/support',
        pageBuilder: (context, state) => _fadeTransitionPage(context, state, const SupportScreen()),
      ),
      GoRoute(
        path: '/settings',
        pageBuilder: (context, state) => _fadeTransitionPage(context, state, const SettingsScreen()),
      ),
      GoRoute(
        path: '/ledger',
        pageBuilder: (context, state) => _fadeTransitionPage(context, state, const OutstandingSummaryScreen()),
      ),
      GoRoute(
        path: '/customers/:id/ledger',
        pageBuilder: (context, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
          return _fadeTransitionPage(context, state, CustomerLedgerScreen(customerId: id));
        },
      ),
      GoRoute(
        path: '/quotations',
        pageBuilder: (context, state) => _fadeTransitionPage(context, state, const QuotationsListScreen()),
      ),
      GoRoute(
        path: '/quotations/new',
        pageBuilder: (context, state) => _fadeTransitionPage(context, state, const QuotationFormScreen()),
      ),
      GoRoute(
        path: '/quotations/:id',
        pageBuilder: (context, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
          return _fadeTransitionPage(context, state, QuotationDetailScreen(quotationId: id));
        },
      ),
    ],
  );
});
