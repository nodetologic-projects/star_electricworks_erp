import 'package:flutter/material.dart';
import 'package:starelectricerp/core/theme/app_theme.dart';

enum StatusBadgeType { 
  paid, pending, overdue, lowStock, partiallyPaid,
  // Motor Job Statuses
  received, inProgress, rewound, dispatched,
  // Copper Stock
  newCopper, oldCopper
}

class StatusBadge extends StatelessWidget {
  final StatusBadgeType type;
  
  const StatusBadge({
    super.key,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor = Colors.white;
    String label;
    IconData? icon;

    switch (type) {
      case StatusBadgeType.paid:
        backgroundColor = AppTheme.successGreen;
        label = 'Paid';
        icon = Icons.check_circle;
        break;
      case StatusBadgeType.pending:
        backgroundColor = AppTheme.warningAmber;
        label = 'Pending';
        icon = Icons.hourglass_empty;
        break;
      case StatusBadgeType.overdue:
        backgroundColor = AppTheme.errorRed;
        label = 'Overdue';
        icon = Icons.error_outline;
        break;
      case StatusBadgeType.partiallyPaid:
        backgroundColor = Colors.purple; // Distinct color as requested
        label = 'Partial';
        icon = Icons.pie_chart_outline;
        break;
      case StatusBadgeType.lowStock:
        backgroundColor = AppTheme.warningAmber;
        label = 'Low Stock';
        icon = Icons.warning_amber_rounded;
        break;
      case StatusBadgeType.received:
        backgroundColor = AppTheme.warningAmber;
        label = 'Received';
        icon = Icons.move_to_inbox;
        break;
      case StatusBadgeType.inProgress:
        backgroundColor = AppTheme.warningAmber;
        label = 'In Progress';
        icon = Icons.engineering;
        break;
      case StatusBadgeType.rewound:
        backgroundColor = AppTheme.successGreen;
        label = 'Rewound';
        icon = Icons.autorenew;
        break;
      case StatusBadgeType.dispatched:
        backgroundColor = AppTheme.successGreen;
        label = 'Dispatched';
        icon = Icons.local_shipping;
        break;
      case StatusBadgeType.newCopper:
        backgroundColor = AppTheme.successGreen;
        label = 'New';
        icon = Icons.fiber_new;
        break;
      case StatusBadgeType.oldCopper:
        backgroundColor = AppTheme.warningAmber;
        label = 'Old';
        icon = Icons.history;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: textColor),
          const SizedBox(width: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}
