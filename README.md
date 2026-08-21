# Star Electric ERP

A custom, offline-first Enterprise Resource Planning application built for Star Electric using Flutter (Windows Desktop).

## Releases & Installation

The application is distributed as a single `.exe` Windows Installer. The build pipeline is fully automated via GitHub Actions.

### Generating a New Release
To trigger a new build and generate the installer:
1. Ensure your local `main` branch is up to date and pushed.
2. Create a new tag (e.g., `v1.0.0`) in Git.
3. Push the tag to GitHub:
   ```bash
   git tag v1.0.0
   git push origin v1.0.0
   ```
4. GitHub Actions will automatically compile the Flutter app, run the Inno Setup compiler, and attach the `.exe` installer directly to the GitHub Release.

### Downloading the Installer
1. Navigate to the **[Releases](../../releases)** tab on GitHub.
2. Under the latest version (e.g., `v1.0.0`), download the attached `StarElectricERP-Setup-1.0.0.exe` file.
3. Run the installer to deploy the application to `C:\Program Files\StarElectricERP`.

---

## Important Notice: Code Signing Certificates

By default, running the downloaded installer will trigger a **Windows SmartScreen** "Unknown Publisher" warning. This is standard behavior for any application downloaded from the internet that is not cryptographically signed by a verified entity.

**How to remove this warning:**
To remove this warning and provide a completely seamless installation experience for the client, you must purchase a **Code Signing Certificate**.

- **Standard Code Signing Certificate**: ~₹4,000–₹6,000 / year. SmartScreen may still warn a few users initially until the certificate gains "reputation" (people running it without reporting it as malware).
- **EV (Extended Validation) Code Signing Certificate**: ~₹15,000+ / year. Requires hardware tokens and rigorous business identity verification. Grants instant SmartScreen reputation, meaning no warnings from day one.

*Note: This is an optional step and is purely for branding/trust. The application functions perfectly regardless of whether it is signed. Discuss this decision with the client before the final handover.*

If you choose to purchase one (e.g., from Sectigo, DigiCert, or SSL.com), the `.pfx` file or hardware token can be integrated into the GitHub Actions pipeline using `signtool.exe` to sign both `starelectricerp.exe` and the `StarElectricERP-Setup.exe` installer.

---

## Development Setup

If you'd like to run the project locally on your machine:
```bash
flutter pub get
flutter run -d windows
```
