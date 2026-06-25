# SharePoint Deployment & Power Automate Setup Guide

## Part 1: Deploy the Time Entry App to SharePoint

### Step 1: Upload the file
1. Go to your SharePoint site
2. Navigate to **Site Contents** → **Site Assets** (or **Documents**)
3. Upload `time-entry.aspx`

### Step 2: Navigate to the page
- Browse to: `https://yourcompany.sharepoint.com/sites/yoursite/SiteAssets/time-entry.aspx`
- The page will load with your SharePoint authentication — engineers are auto-identified by their Windows login
- **Bookmark this URL** and share with your team

### Step 3: Initial Admin Setup
1. Click **Admin Settings** (gear icon, top right)
2. Add your **engineers** — names must match their Active Directory display names for auto-login
3. Add **work categories** (Design, Assembly, Shop Support, etc.)
4. Add **projects** and jobs under each project with hour estimates
5. Add **company holidays** for the year
6. Set the **weighted hourly cost** (default $88/hr)
7. Paste the **Power Automate Flow URL** (see Part 2 below)

### Important Notes
- All admin settings are stored in **browser localStorage** per machine
- For shared settings across all users, the Power Automate flow syncs time entries to a central SharePoint Excel file
- If you need admin settings shared too, you can maintain a central config — ask about this if needed

---

## Part 2: Create the SharePoint Excel File

1. Go to your SharePoint site → **Documents**
2. Create a new Excel workbook: **TimeEntries.xlsx**
3. Open it and create a **Table** (select header row → Insert → Table)
4. Name the table **TimeEntries** (Table Design tab → Table Name)
5. Add these column headers:

| Date | Engineer | Project | Job | Category | Hours | Cost | Note | Type | WeekOf | SubmittedAt |
|------|----------|---------|-----|----------|-------|------|------|------|--------|-------------|

6. Save and close

---

## Part 3: Create the Power Automate Flow

### Step 1: Create the flow
1. Go to [Power Automate](https://make.powerautomate.com)
2. Click **+ Create** → **Instant cloud flow**
3. Name it **"Time Entry Sync"**
4. Choose trigger: **"When an HTTP request is received"**
5. Click **Create**

### Step 2: Configure the HTTP trigger
1. Click on the trigger step
2. In **Request Body JSON Schema**, paste:

```json
{
  "type": "object",
  "properties": {
    "engineer": { "type": "string" },
    "weekOf": { "type": "string" },
    "entries": {
      "type": "array",
      "items": {
        "type": "object",
        "properties": {
          "Date": { "type": "string" },
          "Engineer": { "type": "string" },
          "Project": { "type": "string" },
          "Job": { "type": "string" },
          "Category": { "type": "string" },
          "Hours": { "type": "number" },
          "Cost": { "type": "number" },
          "Note": { "type": "string" },
          "Type": { "type": "string" },
          "WeekOf": { "type": "string" },
          "SubmittedAt": { "type": "string" }
        }
      }
    }
  }
}
```

3. Click **Save** — the **HTTP POST URL** will appear. Copy this URL.

### Step 3: Delete old rows for this engineer + week (prevents duplicates)

1. **+ New step** → **Excel Online (Business)** → **List rows present in a table**
   - Location: your SharePoint site
   - Document Library: Documents
   - File: TimeEntries.xlsx
   - Table: TimeEntries
   - Filter Query: `Engineer eq '` → select **engineer** from dynamic content → `' and WeekOf eq '` → select **weekOf** → `'`

2. **+ New step** → **Apply to each**
   - Select output: **value** from the List rows step
   - Inside: **Add an action** → **Excel Online (Business)** → **Delete a row**
     - Same Location / Library / File / Table
     - Key Column: pick a column (Date works)
     - Key Value: select the row's identifier

### Step 4: Add new rows

1. After the delete loop, **+ New step** → **Apply to each**
   - Select output: **entries** from the trigger
2. Inside: **Add an action** → **Excel Online (Business)** → **Add a row into a table**
   - Location: your SharePoint site
   - Document Library: Documents
   - File: TimeEntries.xlsx
   - Table: TimeEntries
   - Map columns from dynamic content:
     - Date → `Date`
     - Engineer → `Engineer`
     - Project → `Project`
     - Job → `Job`
     - Category → `Category`
     - Hours → `Hours`
     - Cost → `Cost`
     - Note → `Note`
     - Type → `Type`
     - WeekOf → `WeekOf`
     - SubmittedAt → `SubmittedAt`

### Step 5: Add a response

1. **+ New step** → **Response**
   - Status Code: `200`
   - Body: `{"status": "ok"}`
   - Add header: `Access-Control-Allow-Origin` = `*`

2. Click **Save**

### Step 6: Copy the URL into the app

1. Go back to the trigger step → copy the **HTTP POST URL**
2. Open the Time Entry app → **Admin Settings** → paste into **Power Automate Flow URL**
3. Test by saving a week of time — you should see "Synced to SharePoint"
4. Open TimeEntries.xlsx on SharePoint to verify rows appeared

---

## Part 4: Build Your CEO Dashboard

With data flowing into the SharePoint Excel file, you can build dashboards using:

### Power BI (Recommended)
1. Open Power BI Desktop → **Get Data** → **SharePoint folder** or **Web**
2. Connect to your TimeEntries.xlsx
3. Suggested visuals:
   - **Project Health** — Card/matrix with R/Y/G status indicators
   - **Engineering Utilization** — Bar chart: available hours vs logged hours per engineer per week
   - **Project Cost vs Sold** — Clustered bar: sold price vs engineering cost, with margin %
   - **Hours by Category** — Stacked bar: Design vs Assembly vs Shop Support across projects
   - **Weekly Trend** — Line chart: total hours logged per week over time
   - **Budget Burn** — Gauge: estimated hours vs actual per project/job
   - **PTO/Travel Impact** — Shows capacity reduction by week

### Excel Pivot Tables (Quick alternative)
- Open TimeEntries.xlsx → Insert → PivotTable
- Rows: Project, Job | Columns: WeekOf | Values: Sum of Hours, Sum of Cost
- Add slicers for Engineer, Category, Type
