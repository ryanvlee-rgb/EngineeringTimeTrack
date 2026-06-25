# GitHub Actions → SharePoint Deployment Setup

This guide sets up automatic deployment: every time you push changes to `time-entry.html`, it gets uploaded to your SharePoint SiteAssets automatically.

---

## Step 1: Register an App in Azure AD

1. Go to [Azure Portal](https://portal.azure.com)
2. Search for **App registrations** in the top search bar → click it
3. Click **+ New registration**
4. Fill in:
   - **Name:** `SharePoint Deployer`
   - **Supported account types:** "Accounts in this organizational directory only"
   - **Redirect URI:** leave blank
5. Click **Register**
6. On the app's overview page, copy these two values (you'll need them later):
   - **Application (client) ID** → this is your `AZURE_CLIENT_ID`
   - **Directory (tenant) ID** → this is your `AZURE_TENANT_ID`

---

## Step 2: Create a Client Secret

1. In your app registration, click **Certificates & secrets** (left sidebar)
2. Click **+ New client secret**
3. Description: `GitHub Actions`
4. Expires: pick **24 months**
5. Click **Add**
6. **IMMEDIATELY copy the Value** (not the Secret ID) → this is your `AZURE_CLIENT_SECRET`
   - You can only see this once! If you lose it, delete and create a new one.

---

## Step 3: Grant SharePoint Permissions

1. In your app registration, click **API permissions** (left sidebar)
2. Click **+ Add a permission**
3. Click **Microsoft Graph**
4. Click **Application permissions** (not Delegated)
5. Search for and check these permissions:
   - `Sites.ReadWrite.All`
6. Click **Add permissions**
7. Click **Grant admin consent for Stone Enterprises** (the button with the checkmark)
8. Confirm → all permissions should show green checkmarks

---

## Step 4: Get Your SharePoint Site ID and Drive ID

Open PowerShell or a browser and run these Graph API calls. You can use the [Graph Explorer](https://developer.microsoft.com/en-us/graph/graph-explorer) to do this.

### Get Site ID
Make a GET request to:
```
https://graph.microsoft.com/v1.0/sites/stoneent.sharepoint.com:/?$select=id
```
The response will have an `id` field like: `stoneent.sharepoint.com,abc123-...,def456-...`

That full string is your `SHAREPOINT_SITE_ID`.

### Get Drive ID (for SiteAssets)
Make a GET request to:
```
https://graph.microsoft.com/v1.0/sites/{SITE_ID}/drives
```
Look for the drive with `name: "Site Assets"` and copy its `id` field.

That is your `SHAREPOINT_DRIVE_ID`.

---

## Step 5: Add Secrets to GitHub

1. Go to [https://github.com/ryanvlee-rgb/EngineeringTimeTrack/settings/secrets/actions](https://github.com/ryanvlee-rgb/EngineeringTimeTrack/settings/secrets/actions)
2. Click **New repository secret** for each of these:

| Secret Name | Value |
|---|---|
| `AZURE_TENANT_ID` | Directory (tenant) ID from Step 1 |
| `AZURE_CLIENT_ID` | Application (client) ID from Step 1 |
| `AZURE_CLIENT_SECRET` | Client secret Value from Step 2 |
| `SHAREPOINT_SITE_ID` | Site ID from Step 4 |
| `SHAREPOINT_DRIVE_ID` | Drive ID from Step 4 |

---

## Step 6: Test It

1. Make any change to `time-entry.html`
2. Commit and push to `main`
3. Go to [https://github.com/ryanvlee-rgb/EngineeringTimeTrack/actions](https://github.com/ryanvlee-rgb/EngineeringTimeTrack/actions)
4. You should see the "Deploy to SharePoint" workflow running
5. Once it completes (green checkmark), verify the file updated at:
   `https://stoneent.sharepoint.com/SiteAssets/time-entry.html`

### Manual Deploy
You can also trigger a deploy manually:
1. Go to the Actions tab on GitHub
2. Click "Deploy to SharePoint" on the left
3. Click **Run workflow** → **Run workflow**

---

## Troubleshooting

| Problem | Fix |
|---|---|
| "Failed to get access token" | Check AZURE_TENANT_ID, CLIENT_ID, and CLIENT_SECRET are correct |
| "403 Forbidden" on upload | Make sure you granted admin consent in Step 3 |
| "404 Not Found" on upload | Check SHAREPOINT_SITE_ID and SHAREPOINT_DRIVE_ID |
| Workflow doesn't trigger | Make sure you pushed to `main` branch and changed `time-entry.html` |
