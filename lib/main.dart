import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:starelectricerp/core/routing/app_router.dart';
import 'package:starelectricerp/core/theme/app_theme.dart';
import 'package:starelectricerp/features/auth/widgets/inactivity_wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  final container = ProviderContainer();
  
  // Non-blocking initialization

  runApp(
    UncontrolledProviderScope(
      container: container,
      child: const MyApp(),
    ),
  );
}

class NewInvoiceIntent extends Intent { const NewInvoiceIntent(); }
class NewJobIntent extends Intent { const NewJobIntent(); }

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);
    final isMac = Platform.isMacOS;

    return Shortcuts(
      shortcuts: <ShortcutActivator, Intent>{
        SingleActivator(LogicalKeyboardKey.keyN, control: !isMac, meta: isMac): const NewInvoiceIntent(),
        SingleActivator(LogicalKeyboardKey.keyJ, control: !isMac, meta: isMac): const NewJobIntent(),
      },
      child: Actions(
        actions: <Type, Action<Intent>>{
          NewInvoiceIntent: CallbackAction<NewInvoiceIntent>(
            onInvoke: (intent) => router.push('/invoices/new'),
          ),
          NewJobIntent: CallbackAction<NewJobIntent>(
            onInvoke: (intent) => router.push('/jobs/new'),
          ),
        },
        child: InactivityWrapper(
          child: MaterialApp.router(
            title: 'Star Electric ERP',
            theme: AppTheme.themeData,
            routerConfig: router,
          ),
        ),
      ),
    );
  }
}
