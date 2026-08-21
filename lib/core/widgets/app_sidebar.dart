import 'package:flutter/material.dart';
import 'package:starelectricerp/core/theme/app_theme.dart';

class AppSidebarItem {
  final String label;
  final IconData icon;
  final String route;

  AppSidebarItem({
    required this.label,
    required this.icon,
    required this.route,
  });
}

class AppSidebar extends StatelessWidget {
  final List<AppSidebarItem> items;
  final String currentRoute;
  final ValueChanged<String> onNavigate;

  const AppSidebar({
    super.key,
    required this.items,
    required this.currentRoute,
    required this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      color: AppTheme.textPrimary,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Row(
              children: [
                Image.asset(
                  'assets/icon/app_icon.png',
                  width: 40,
                  height: 40,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Star Electric',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                final isSelected = currentRoute.startsWith(item.route);

                return InkWell(
                  onTap: () => onNavigate(item.route),
                  child: Container(
                    color: isSelected ? AppTheme.primaryMaroon : Colors.transparent,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    child: Row(
                      children: [
                        Icon(
                          item.icon,
                          color: isSelected ? Colors.white : Colors.white70,
                          size: 20,
                        ),
                        const SizedBox(width: 16),
                        Text(
                          item.label,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.white70,
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
