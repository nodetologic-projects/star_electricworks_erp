import re

def remove_line(file, pattern):
    with open(file, 'r') as f:
        content = f.read()
    content = re.sub(pattern, "", content)
    with open(file, 'w') as f:
        f.write(content)

# 1. quotations_repository.dart
remove_line('lib/data/repositories/quotations_repository.dart', r"import 'package:drift/drift.dart' as import_drift;\n")

# 2. employee_list_screen.dart
remove_line('lib/features/attendance/screens/employee_list_screen.dart', r"\s*Future<void> _confirmDelete.*?\}\n")

# 3. add_transaction_dialog.dart
remove_line('lib/features/cashbook/screens/add_transaction_dialog.dart', r"\s*final repo = ref.read\(cashbookRepositoryProvider\);\n")

# 4 & 5. copper_stock_list_screen.dart
remove_line('lib/features/copper_stock/screens/copper_stock_list_screen.dart', r"\s*@override\n\s*Future<void> _confirmDelete.*?\}\n")

print("Done")
