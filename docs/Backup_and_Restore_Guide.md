# Star Electric ERP: Backup & Restore Guide

Data security is paramount. The ERP offers two distinct backup methods accessible via the **Settings** screen.

## 1. Local Offline Backup
Use this method to save a snapshot of your database to a USB drive or local folder.

**To Backup:**
1. Go to **Settings > Data Backup**.
2. Click **Export Local Backup**.
3. A file picker will appear. Choose where you want to save the `.zip` file (e.g., your external hard drive).
4. Keep this `.zip` file safe. It contains your SQLite database, company logo, and all signed PDF invoices.

**To Restore:**
1. Click **Restore Local Backup** and select your `.zip` file.
2. The system will extract and validate the backup.
3. *Safety Measure*: Before overwriting your live data, the system automatically creates a `starelectricerp_safety_copy.sqlite` file in your application directory. If the restore fails or the backup is corrupted, your original data is safe.

## 2. Google Drive Cloud Backup
Use this method for automated, off-site cloud storage.

**Setup & Authentication:**
1. Go to **Settings > Data Backup**.
2. Click **Authenticate with Google Drive**.
3. A browser window will open. Sign in with your Google account and grant the app permission to manage files in its specific App Folder.

**To Backup:**
1. Once authenticated, click **Backup to Google Drive**.
2. The app will compress your database and upload it silently.
3. The system automatically manages your storage by keeping only the 10 most recent backups, deleting the oldest ones automatically to save space.

**To Restore:**
1. The Drive section will list all available backups stored in the cloud, showing their date and size.
2. Click the **Restore** icon next to the desired backup.
3. Just like the local restore, a safety copy of your current data is made before the cloud data is applied.
