import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final goRouter = GoRouter(
  initialLocation: '/dashboard',
  routes: [
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const PlaceholderScreen(title: 'Dashboard'),
    ),
    GoRoute(
      path: '/invoices',
      builder: (context, state) => const PlaceholderScreen(title: 'Invoices'),
    ),
    GoRoute(
      path: '/products',
      builder: (context, state) => const PlaceholderScreen(title: 'Products'),
    ),
    GoRoute(
      path: '/customers',
      builder: (context, state) => const PlaceholderScreen(title: 'Customers'),
    ),
    GoRoute(
      path: '/reports',
      builder: (context, state) => const PlaceholderScreen(title: 'Reports'),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => const PlaceholderScreen(title: 'Settings'),
    ),
  ],
);

class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title, style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 20),
            Wrap(
              spacing: 8.0,
              children: [
                ElevatedButton(
                  onPressed: () => context.go('/dashboard'),
                  child: const Text('Dashboard'),
                ),
                ElevatedButton(
                  onPressed: () => context.go('/invoices'),
                  child: const Text('Invoices'),
                ),
                ElevatedButton(
                  onPressed: () => context.go('/products'),
                  child: const Text('Products'),
                ),
                ElevatedButton(
                  onPressed: () => context.go('/customers'),
                  child: const Text('Customers'),
                ),
                ElevatedButton(
                  onPressed: () => context.go('/reports'),
                  child: const Text('Reports'),
                ),
                ElevatedButton(
                  onPressed: () => context.go('/settings'),
                  child: const Text('Settings'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
