import sys

with open("lib/core/routing/app_router.dart", "r") as f:
    content = f.read()

target = """      GoRoute(
        path: '/invoices/:id',
        pageBuilder: (context, state) {"""

patch = """      GoRoute(
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
        pageBuilder: (context, state) {"""

if patch in content:
    print("Already patched")
    sys.exit(0)

new_content = content.replace(target, patch)

with open("lib/core/routing/app_router.dart", "w") as f:
    f.write(new_content)

print("Patched router")
