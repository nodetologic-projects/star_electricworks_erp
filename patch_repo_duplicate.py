import sys

with open("lib/data/repositories/invoices_repository.dart", "r") as f:
    content = f.read()

target = """    final query = _db.select(_db.invoices)
      ..where((t) => t.customerId.equals(customerId) &
                     t.invoiceType.equals(type.name) &
                     t.grandTotal.equals(grandTotal) &
                     t.invoiceDate.isBetweenValues(cutoff, date))
      ..orderBy([(t) => OrderingTerm(expression: t.invoiceDate, mode: OrderingMode.desc)])
      ..limit(1);"""

patch = """    final query = _db.select(_db.invoices)
      ..where((t) {
        var expr = t.customerId.equals(customerId) &
                     t.invoiceType.equals(type.name) &
                     t.grandTotal.equals(grandTotal) &
                     t.invoiceDate.isBetweenValues(cutoff, date);
        if (excludeInvoiceId != null) {
          expr = expr & t.id.isNotValue(excludeInvoiceId);
        }
        return expr;
      })
      ..orderBy([(t) => OrderingTerm(expression: t.invoiceDate, mode: OrderingMode.desc)])
      ..limit(1);"""

content = content.replace(target, patch)

with open("lib/data/repositories/invoices_repository.dart", "w") as f:
    f.write(content)
