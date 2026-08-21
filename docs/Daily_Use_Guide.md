# Star Electric ERP: Daily Use Guide

## 1. Motor Jobs & Dispatch Flow
The core workflow for repairing/rewinding motors is managed under the **Motor Jobs** tab.

1. **Create a Job**: Click "+ New Motor Job". Enter the customer details (use the auto-fill dropdown if it's an existing customer), motor specifications (HP, RPM, Serial No), and observed issues.
2. **Advance Status**: Open the Job Detail view. As work progresses, use the "Advance Status" button to move the job from `Received` → `In Progress` → `Rewound`.
3. **Generate Delivery Challan**: Once the motor is `Rewound`, you must generate a **Delivery Challan** to authorize physical transport. Click "Generate Delivery Challan" from the job detail screen.
4. **Dispatch**: After the challan is generated, you can advance the job status one final time to `Dispatched`. (The system will block this action if no challan exists).

## 2. Quotations & Billing
### Quotations
1. Go to **Quotations** and click "+ New Quotation".
2. Fill in the estimated scope of work and amount. This generates a PDF clearly marked as "NOT A TAX INVOICE".
3. Once the customer approves, open the quotation and click **Mark Accepted**.
4. Click **Convert to Invoice**. The system will carry over all data into a new Service Tax Invoice draft.

### Generating Invoices
You can generate 4 types of documents from the **Invoices** tab:
- **Service Tax Invoice**: For repair/rewinding labor.
- **Sales Tax Invoice**: For selling physical goods (e.g., copper wire, capacitors). Deducts from Copper Stock.
- **Bill of Supply**: For GST-exempt sales (no tax is computed). Deducts from Copper Stock.
- **Delivery Challan**: For moving goods without a sale.

*Note: Invoices over ₹50,000 for physical goods automatically flag themselves as requiring an e-Way Bill.*

### Recording Payments
1. Open any finalized invoice and click **Record Payment**.
2. Enter the amount received, payment mode (Cash, Bank, UPI, Cheque), and a reference number.
3. The invoice status will automatically update to `Partially Paid` or `Paid` based on the balance due.
4. View consolidated outstanding balances under the **Ledger** tab.

## 3. Inventory (Copper Stock)
- **Add Stock**: Go to **Copper Stock** and add a new spool/batch.
- **Purchase Vouchers**: To increase stock, use the "Adjust Stock" dialog or register a Purchase Voucher.
- **Auto-Deduction**: Selling stock via a Sales Tax Invoice or Bill of Supply automatically deducts the exact weight from your inventory in real-time.

## 4. Attendance & Wages
- Navigate to **Attendance**.
- Click **Mark Daily Attendance** to bulk-mark Present, Absent, or Half-Day for all active employees for the current day.
- View the **History** tab to edit past days.
- The system automatically aggregates these records to provide a monthly wage estimate based on each employee's configured base rate.

## 5. Cash Book
- Use the **Cash Book** tab for internal tracking of petty cash and miscellaneous daily expenses/incomes.
- Transactions logged here are strictly internal and **do not** appear on GST reports or official ledgers.
- The running balance at the top of the screen updates instantly with every entry.
