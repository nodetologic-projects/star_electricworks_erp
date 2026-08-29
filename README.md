# Star Electric ERP

A robust, offline-first Enterprise Resource Planning application built specifically for **Star Electric Works**. Built with Flutter for Desktop (Windows & macOS), this application manages the core business workflows of motor repair jobs, inventory, invoicing, and financial reporting with a focus on data privacy and local storage.

---

## 🌟 Key Features

### 🛠️ Motor Job Management
* End-to-end lifecycle tracking of motor repair jobs (Received -> In Progress -> Completed -> Delivered).
* Track motor specifications (HP, RPM, Make), received items, and required materials (Copper wire, insulation, bearings).
* Integrated generation of Quotations directly from job estimations.

### 💰 Billing & Invoicing (GST Ready)
* Generate professional PDF invoices (Tax Invoice, Delivery Challan, Quotations).
* Robust tax calculations supporting CGST, SGST, and IGST based on intra/inter-state logic.
* **UPI QR Code Integration:** Automatically generates scannable UPI deep-link QR codes on invoices for instant payments.
* **Native E-Way / E-Invoice Tracking:** Flags and fields to track IRN numbers and E-Way bill requirements.
* Configurable company settings (Bank Details, GSTIN, UPI ID, Terms & Conditions).

### 🖋️ Digital Signature (DSC) Integration
* **Direct USB Token Signing:** Uniquely integrates a bundled C# helper (`pdf_signer.exe`) utilizing the Windows Cryptographic API to sign PDFs using a physical USB Crypto Token (e-Pass 2003 / ProxKey).
* 1-Click "Sign & Print" workflow straight from the app UI.

### 📦 Inventory & Copper Stock
* Real-time tracking of new and scrap copper stock by weight (kg).
* Configurable low-stock threshold alerts.
* Granular stock adjustment logs for auditing additions and deductions.

### 📊 Cash Book & Customer Ledger
* **Cash Book:** Track daily petty cash, incomes, and expenses. Link direct purchases to cash book transactions automatically.
* **Customer Ledger:** Unified view of all active customers, outstanding balances, and payment histories.
* Track partial payments, full payments, and overdue statuses.

### 🔐 Security & Data Management
* **Offline-First:** All data lives securely on the client machine using a local SQLite database.
* **Automated Backups:** Scheduled and manual database backups.
* **Google Drive Sync:** Direct integration with Google Drive to securely upload AES-encrypted database backups to the cloud.
* **PIN Lock:** Secure application access with a configurable numeric PIN.

### 📁 CA Export
* Generate a cleanly zipped archive of signed or drafted PDFs, filtered by month and year, ready to be emailed to the Chartered Accountant.

---

## 💻 Tech Stack

* **Frontend framework:** Flutter (Desktop - Windows & macOS)
* **State Management:** Riverpod
* **Database:** SQLite via Drift (Dart's reactive ORM)
* **Native Integrations:** 
  * C# / .NET (for Windows USB Token PDF signing via `BouncyCastle` & `iTextSharp`)
  * Windows `print` API integration.
* **Packaging:** Inno Setup Compiler (`iscc`)

---

## 🚀 Local Development Setup

### Prerequisites
1. **Flutter SDK** (stable channel) installed and configured for Windows/macOS desktop development.
2. **.NET SDK** (if you need to compile the C# PDF signer).

### Getting Started
```bash
# Clone the repository
git clone https://github.com/nodetologic-projects/star_electricworks_erp.git

# Install dependencies
flutter pub get

# Generate Drift database files and Riverpod providers
dart run build_runner build -d

# Run the application
flutter run -d windows  # Or macos
```

### Environment Variables
For Google Drive backup to function locally, you need to populate OAuth credentials:
1. Create `lib/core/config/google_credentials.dart`
2. Add your OAuth Client ID and Secret:
```dart
class GoogleCredentials {
  static const clientId = 'YOUR_CLIENT_ID.apps.googleusercontent.com';
  static const clientSecret = 'YOUR_CLIENT_SECRET';
}
```
*(Note: These are injected automatically during the GitHub Actions release build via repository secrets).*

---

## 📦 Releases & Automated CI/CD

The application is distributed as a single `.exe` Windows Installer. The build pipeline is fully automated via **GitHub Actions**.

### Generating a New Release
To trigger a new build and generate the installer:
1. Ensure your local `main` branch is up to date and pushed.
2. Create a new tag (e.g., `v1.0.21`) in Git.
3. Push the tag to GitHub:
   ```bash
   git tag v1.0.21
   git push origin v1.0.21
   ```
4. GitHub Actions will automatically compile the Flutter app, run the Inno Setup compiler, and attach the `.exe` installer directly to the new GitHub Release.

### Downloading the Installer
1. Navigate to the **[Releases](https://github.com/nodetologic-projects/star_electricworks_erp/releases)** tab on GitHub.
2. Download the attached `StarElectricERP-Setup-1.0.21.exe` file.
3. Run the installer to deploy the application to `C:\Program Files\StarElectricERP`.

---

## ⚠️ Important Notice: Code Signing Certificates

By default, running the downloaded installer will trigger a **Windows SmartScreen** "Unknown Publisher" warning. This is standard behavior for any application downloaded from the internet that is not cryptographically signed by a verified entity.

**How to remove this warning:**
To remove this warning and provide a completely seamless installation experience for the client, you must purchase a **Code Signing Certificate**.

- **Standard Code Signing Certificate**: SmartScreen may still warn a few users initially until the certificate gains "reputation" (people running it without reporting it as malware).
- **EV (Extended Validation) Code Signing Certificate**: Requires hardware tokens and rigorous business identity verification. Grants instant SmartScreen reputation, meaning no warnings from day one.

*Note: This is an optional step and is purely for branding/trust. The application functions perfectly regardless of whether it is signed.*

If you choose to purchase one, the `.pfx` file or hardware token can be integrated into the GitHub Actions pipeline using `signtool.exe` to sign both `starelectricerp.exe` and the `StarElectricERP-Setup.exe` installer.
