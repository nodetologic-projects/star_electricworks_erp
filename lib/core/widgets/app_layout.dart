import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:starelectricerp/core/widgets/app_sidebar.dart';
import 'package:starelectricerp/core/routing/sidebar_items.dart';
import 'package:starelectricerp/core/updater/updater_service.dart';

class AppLayout extends ConsumerStatefulWidget {
  final Widget child;
  final String currentRoute;
  final PreferredSizeWidget? appBar;
  final Widget? floatingActionButton;

  const AppLayout({
    super.key,
    required this.child,
    required this.currentRoute,
    this.appBar,
    this.floatingActionButton,
  });

  @override
  ConsumerState<AppLayout> createState() => _AppLayoutState();
}

class _AppLayoutState extends ConsumerState<AppLayout> {
  static bool _hasCheckedUpdate = false;

  @override
  void initState() {
    super.initState();
    if (!_hasCheckedUpdate) {
      _hasCheckedUpdate = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _checkForUpdates();
      });
    }
  }

  Future<void> _checkForUpdates() async {
    final updater = ref.read(updaterServiceProvider);
    final updateInfo = await updater.checkForUpdates();
    if (updateInfo != null && updateInfo.hasUpdate && mounted) {
      ScaffoldMessenger.of(context).showMaterialBanner(
        MaterialBanner(
          content: Text('A new version (${updateInfo.latestVersion}) is available - ${updateInfo.releaseNotes}'),
          leading: const Icon(Icons.system_update, color: Colors.blue),
          actions: [
            TextButton(
              onPressed: () {
                updater.launchDownloadUrl(updateInfo.downloadUrl);
              },
              child: const Text('Download'),
            ),
            TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
              },
              child: const Text('Dismiss'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 800;

        if (isMobile) {
          return Scaffold(
            appBar: widget.appBar,
            drawer: Drawer(
              child: AppSidebar(
                currentRoute: widget.currentRoute,
                items: kSidebarItems,
                onNavigate: (route) {
                  context.pop(); // Close drawer
                  context.go(route);
                },
              ),
            ),
            body: widget.child,
            floatingActionButton: widget.floatingActionButton,
          );
        } else {
          return Scaffold(
            body: Row(
              children: [
                AppSidebar(
                  currentRoute: widget.currentRoute,
                  items: kSidebarItems,
                  onNavigate: (route) => context.go(route),
                ),
                Expanded(
                  child: Scaffold(
                    appBar: widget.appBar,
                    body: widget.child,
                    floatingActionButton: widget.floatingActionButton,
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }
}
