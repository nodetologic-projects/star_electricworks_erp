# Star Electric ERP: What's Not Included (Scope Boundaries)

To ensure expectations remain aligned with the original project roadmap and scope documents, please review the following features that are explicitly **out of scope** for this software version.

## 1. Direct GST Portal Integration (GSTR Filing)
- **What it does**: The ERP calculates CGST, SGST, and IGST perfectly, tracks ₹50k thresholds for e-Way Bills, and generates clean Excel reports summarizing your monthly tax liabilities.
- **What it DOES NOT do**: The app does not connect directly to the government GST portal via API. You cannot file GSTR-1 or GSTR-3B directly from the app. You must export the Excel reports and hand them to your CA/Accountant to file manually.

## 2. Multi-User Authentication & Networking
- **What it does**: The app features a robust App Lock (PIN) system to deter unauthorized casual access if you step away from your desk.
- **What it DOES NOT do**: This is a single-machine, local desktop application. It does not support multiple user accounts, role-based access control (Admin vs. Employee), or syncing data live across multiple computers on a local network.

## 3. Comprehensive HR & Payroll
- **What it does**: The Attendance module tracks daily present/absent states and calculates a basic monthly wage estimate based on a flat daily rate.
- **What it DOES NOT do**: It does not handle complex payroll accounting, PF (Provident Fund), ESI contributions, overtime multipliers, or advanced leave balances.

## 4. Formal Accounting Ledger integration
- **What it does**: The Cash Book allows for informal, internal tracking of petty cash and daily miscellaneous expenses.
- **What it DOES NOT do**: The Cash Book entries are not linked to your official GST billing or customer ledger. It is not a double-entry accounting system and cannot produce balance sheets or P&L statements.
