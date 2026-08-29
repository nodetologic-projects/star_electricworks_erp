import 'package:flutter/material.dart';
import 'package:starelectricerp/core/widgets/app_sidebar.dart';

final List<AppSidebarItem> kSidebarItems = [
  AppSidebarItem(label: 'Dashboard', icon: Icons.dashboard, route: '/dashboard'),
  AppSidebarItem(label: 'Motor Jobs', icon: Icons.engineering, route: '/jobs'),
  AppSidebarItem(label: 'Quotations', icon: Icons.request_quote, route: '/quotations'),
  AppSidebarItem(label: 'Ledger', icon: Icons.book, route: '/ledger'),
  AppSidebarItem(label: 'Invoices', icon: Icons.receipt_long, route: '/invoices'),
  AppSidebarItem(label: 'Copper Stock', icon: Icons.inventory_2, route: '/stock'),
  AppSidebarItem(label: 'Customers', icon: Icons.people, route: '/customers'),
  AppSidebarItem(label: 'Attendance', icon: Icons.how_to_reg, route: '/attendance'),
  AppSidebarItem(label: 'Cash Book', icon: Icons.account_balance_wallet, route: '/cashbook'),
  AppSidebarItem(label: 'Purchases', icon: Icons.shopping_cart, route: '/purchases'),
  AppSidebarItem(label: 'Reports', icon: Icons.bar_chart, route: '/reports'),
  AppSidebarItem(label: 'Settings', icon: Icons.settings, route: '/settings'),
  AppSidebarItem(label: 'Support', icon: Icons.help_outline, route: '/support'),
];
