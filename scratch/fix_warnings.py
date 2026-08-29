import re

def remove_line(file, pattern):
    with open(file, 'r') as f:
        content = f.read()
    content = re.sub(pattern, "", content)
    with open(file, 'w') as f:
        f.write(content)

# 1. quotations_repository.dart
remove_line('lib/data/repositories/quotations_repository.dart', r"import 'package:drift/drift.dart';\n")

# 2. employee_list_screen.dart
remove_line('lib/features/attendance/screens/employee_list_screen.dart', r"import 'package:drift/drift.dart';\n")

# 3. cashbook/screens/add_transaction_dialog.dart (unused variable repo)
remove_line('lib/features/cashbook/screens/add_transaction_dialog.dart', r"\s*final repo = ref.read\(cashbookRepositoryProvider\);\n")

# 4. copper_stock_list_screen.dart
remove_line('lib/features/copper_stock/screens/copper_stock_list_screen.dart', r"import 'package:starelectricerp/data/database.dart';\n")
remove_line('lib/features/copper_stock/screens/copper_stock_list_screen.dart', r"import 'package:starelectricerp/data/repositories/copper_stock_repository.dart';\n")

# 5. purchases/screens/add_purchase_screen.dart (unnecessary null comparison)
remove_line('lib/features/purchases/screens/add_purchase_screen.dart', r" && item\.amount != null")

print("Done")
