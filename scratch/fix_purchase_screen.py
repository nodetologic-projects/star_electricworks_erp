import re

with open('lib/features/purchases/screens/add_purchase_screen.dart', 'r') as f:
    content = f.read()

# Fix purchaseId
content = content.replace("PurchaseItemsCompanion.insert(\n      category: item.category,", "PurchaseItemsCompanion.insert(\n      purchaseId: 0,\n      category: item.category,")

# Fix cashbook category
content = content.replace("category: drift.Value('Purchase'),", "category: 'Purchase',")

# We must replace AppTextField with initialValue to TextFormField for the dynamic list.
apptextfield_desc_old = """                              child: AppTextField(
                                label: 'Description',
                                initialValue: item.description,"""
apptextfield_desc_new = """                              child: TextFormField(
                                decoration: const InputDecoration(labelText: 'Description', border: OutlineInputBorder()),
                                initialValue: item.description,"""
content = content.replace(apptextfield_desc_old, apptextfield_desc_new)

apptextfield_amt_old = """                              child: AppTextField(
                                label: 'Amount (₹)',
                                initialValue: item.amount > 0 ? item.amount.toString() : '',"""
apptextfield_amt_new = """                              child: TextFormField(
                                decoration: const InputDecoration(labelText: 'Amount (₹)', border: OutlineInputBorder()),
                                initialValue: item.amount > 0 ? item.amount.toString() : '',"""
content = content.replace(apptextfield_amt_old, apptextfield_amt_new)

apptextfield_gst_old = """                              child: AppTextField(
                                label: 'GST Amount (₹)',
                                initialValue: item.gstAmount > 0 ? item.gstAmount.toString() : '',"""
apptextfield_gst_new = """                              child: TextFormField(
                                decoration: const InputDecoration(labelText: 'GST Amount (₹)', border: OutlineInputBorder()),
                                initialValue: item.gstAmount > 0 ? item.gstAmount.toString() : '',"""
content = content.replace(apptextfield_gst_old, apptextfield_gst_new)

with open('lib/features/purchases/screens/add_purchase_screen.dart', 'w') as f:
    f.write(content)

print("Done")
