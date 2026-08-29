import sys

with open("lib/features/billing/screens/invoice_form_screen.dart", "r") as f:
    content = f.read()

target = """                ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 80,
          child: TextFormField(
            key: ValueKey('qty_${index}_${item.linkedId}'),"""

patch = """                ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 100,
          child: TextFormField(
            key: ValueKey('raters_${index}_${item.linkedId}'),
            initialValue: item.rateRs ?? '',
            decoration: const InputDecoration(labelText: 'Rate/RS'),
            onChanged: (val) => item.rateRs = val,
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 80,
          child: TextFormField(
            key: ValueKey('qty_${index}_${item.linkedId}'),"""

content = content.replace(target, patch)

with open("lib/features/billing/screens/invoice_form_screen.dart", "w") as f:
    f.write(content)
