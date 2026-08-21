# Star Electric ERP: Getting Started

## 1. Installation Steps
1. Download the latest `StarElectricERP-Setup-x.x.x.exe` from the provided secure link.
2. Double-click the installer and follow the on-screen prompts.
3. Once installed, a shortcut will be created on your Desktop and Start Menu.
4. If you plan to use USB Token (Hardware) DSC signing, ensure your token drivers (e.g., ePass2003) are installed on your Windows machine.

## 2. First-Launch Walkthrough
Upon opening Star Electric ERP for the first time, you will be greeted by the Dashboard. Before generating any invoices or quotations, you must configure your company details.

1. Navigate to **Settings** using the left-hand sidebar.
2. You will see several configuration cards. Start with the **Company Profile**.

## 3. Configuring Company Settings
In the **Settings** screen, fill out the following sections:

### Company Details & Logo
- Enter your exact Business Name, Address, and Contact details.
- **GSTIN**: Enter your 15-character GSTIN. This is critical for tax calculations and e-Way Bill/e-Invoice applicability.
- **Logo**: Click "Select Logo" to upload your company logo (PNG/JPG). This will appear on all printed PDFs.

### Bank Details
- Scroll down to the **Bank Details** section.
- Enter your Bank Name, Account Name, Account Number, and IFSC Code. These details are automatically appended to the footer of every generated invoice to facilitate client payments.

### Digital Signature Certificate (DSC) Configuration
- Scroll to the **Digital Signature Certificate** section.
- Select your preferred method: **File-based (.pfx)** or **USB Token (Hardware)**.
- **For File-based**: Select your `.pfx` or `.p12` file and enter the certificate password.
- **For USB Token**: Verify the PKCS#11 DLL path (default is usually `C:\Windows\System32\eps2003csp11.dll` for ePass tokens). You will be prompted for your PIN at the exact moment of signing an invoice.

*Note: Your PIN/Password is stored securely using OS-level encryption and is never logged or exposed in plaintext.*

---
*Once these settings are saved, your ERP is ready for daily use! Proceed to the Daily Use Guide.*
