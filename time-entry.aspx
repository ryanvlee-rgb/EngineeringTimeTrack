<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Engineer Time Entry</title>
  <style>
    * { box-sizing: border-box; margin: 0; padding: 0; }
    body { font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif; background: #f0f2f5; color: #1a1a2e; min-height: 100vh; }
    .container { max-width: 1200px; margin: 0 auto; padding: 24px; }

    .top-bar { display: flex; align-items: center; justify-content: space-between; margin-bottom: 24px; }
    .top-bar h1 { font-size: 1.5rem; }
    .gear-btn { background: none; border: 1px solid #d0d5dd; border-radius: 8px; padding: 8px 16px; font-size: 0.88rem; font-weight: 600; cursor: pointer; color: #555; display: flex; align-items: center; gap: 6px; }
    .gear-btn:hover { background: #f0f2f5; color: #333; }

    .card { background: #fff; border-radius: 10px; box-shadow: 0 1px 3px rgba(0,0,0,0.1); padding: 24px; margin-bottom: 24px; }
    .card h2 { font-size: 1.1rem; margin-bottom: 16px; color: #333; }

    .form-row { display: flex; gap: 14px; flex-wrap: wrap; align-items: flex-end; }
    .form-group { display: flex; flex-direction: column; flex: 1; min-width: 130px; }
    .form-group label { font-size: 0.82rem; font-weight: 600; margin-bottom: 5px; color: #555; }
    .form-group input, .form-group select { padding: 9px 11px; border: 1px solid #d0d5dd; border-radius: 6px; font-size: 0.92rem; }
    .form-group input:focus, .form-group select:focus { outline: none; border-color: #4a6cf7; box-shadow: 0 0 0 3px rgba(74,108,247,0.15); }

    .btn { padding: 9px 18px; border: none; border-radius: 6px; font-size: 0.92rem; font-weight: 600; cursor: pointer; transition: background 0.15s; }
    .btn-primary { background: #4a6cf7; color: #fff; }
    .btn-primary:hover { background: #3b5de7; }
    .btn-secondary { background: #e8ecf1; color: #333; }
    .btn-secondary:hover { background: #d8dde5; }
    .btn-danger { background: #fee; color: #c00; font-size: 0.8rem; padding: 4px 10px; }
    .btn-danger:hover { background: #fcc; }
    .btn-sm { padding: 5px 12px; font-size: 0.82rem; }
    .btn-group { display: flex; gap: 10px; margin-top: 8px; align-items: center; }

    .toast { position: fixed; bottom: 24px; right: 24px; background: #1a1a2e; color: #fff; padding: 12px 20px; border-radius: 8px; font-size: 0.9rem; opacity: 0; transition: opacity 0.3s; pointer-events: none; z-index: 200; }
    .toast.show { opacity: 1; }

    .summary { display: flex; gap: 14px; flex-wrap: wrap; margin-bottom: 16px; }
    .stat { background: #f8f9fb; padding: 11px 16px; border-radius: 8px; flex: 1; min-width: 105px; }
    .stat .label { font-size: 0.7rem; text-transform: uppercase; color: #888; }
    .stat .value { font-size: 1.25rem; font-weight: 700; margin-top: 2px; }
    .stat.warn .value { color: #dc2626; }
    .stat.good .value { color: #16a34a; }

    .week-nav { display: flex; align-items: center; gap: 14px; margin-bottom: 16px; flex-wrap: wrap; }
    .week-nav button { background: #e8ecf1; border: none; border-radius: 6px; padding: 8px 14px; cursor: pointer; font-size: 1rem; font-weight: 600; }
    .week-nav button:hover { background: #d8dde5; }
    .week-label { font-size: 1rem; font-weight: 600; min-width: 240px; text-align: center; }

    .timesheet { width: 100%; border-collapse: collapse; }
    .timesheet th { font-size: 0.7rem; text-transform: uppercase; color: #888; padding: 7px 4px; border-bottom: 2px solid #eee; text-align: center; }
    .timesheet th:first-child { text-align: left; min-width: 200px; }
    .timesheet th.today { color: #4a6cf7; }
    .timesheet td { padding: 4px; border-bottom: 1px solid #f0f0f0; text-align: center; }
    .timesheet td:first-child { text-align: left; padding-left: 8px; font-size: 0.84rem; }
    .timesheet .row-total { font-weight: 700; background: #f8f9fb; min-width: 50px; }
    .timesheet tfoot td { border-top: 2px solid #ddd; font-weight: 700; font-size: 0.85rem; background: #f8f9fb; }
    .timesheet input[type="number"] { width: 56px; padding: 4px 2px; border: 1px solid #e0e0e0; border-radius: 5px; text-align: center; font-size: 0.85rem; background: #fafbfc; }
    .timesheet input[type="number"]:focus { border-color: #4a6cf7; background: #fff; outline: none; box-shadow: 0 0 0 2px rgba(74,108,247,0.15); }
    .timesheet input[type="number"].has-value { background: #fff; border-color: #bbb; }
    .timesheet tr.pto-row td { background: #fef3c7; }
    .timesheet tr.pto-row td:first-child { color: #92400e; font-weight: 600; }
    .timesheet tr.travel-row td { background: #e0f2fe; }
    .timesheet tr.travel-row td:first-child { color: #0369a1; font-weight: 600; }
    .timesheet tr.holiday-row td { background: #f0fdf4; color: #166534; font-style: italic; }
    .timesheet tr.project-header td { background: #e0e7ff; font-weight: 700; color: #3730a3; border-top: 2px solid #c7d2fe; }
    .timesheet tr.category-row td:first-child { padding-left: 24px; font-weight: 400; color: #555; font-size: 0.82rem; }

    .remove-row-btn { background: none; border: none; color: #c00; cursor: pointer; font-size: 1rem; padding: 2px 5px; border-radius: 4px; }
    .remove-row-btn:hover { background: #fee; }
    .empty-state { text-align: center; padding: 28px; color: #999; }
    .unsaved-badge { display: inline-block; background: #fff3cd; color: #856404; font-size: 0.75rem; padding: 2px 8px; border-radius: 10px; margin-left: 8px; font-weight: 600; }

    .capacity-bar { height: 8px; background: #e5e7eb; border-radius: 4px; overflow: hidden; margin-top: 4px; }
    .capacity-bar .fill { height: 100%; border-radius: 4px; transition: width 0.3s; }
    .capacity-bar .fill.green { background: #22c55e; }
    .capacity-bar .fill.yellow { background: #eab308; }
    .capacity-bar .fill.red { background: #ef4444; }

    .sync-status { display: inline-flex; align-items: center; gap: 6px; font-size: 0.8rem; margin-left: 12px; }
    .sync-dot { width: 8px; height: 8px; border-radius: 50%; display: inline-block; }
    .sync-dot.success { background: #22c55e; }
    .sync-dot.error { background: #ef4444; }
    .sync-dot.pending { background: #f59e0b; animation: pulse 1s infinite; }
    @keyframes pulse { 0%,100%{opacity:1} 50%{opacity:0.4} }

    /* ===== ADMIN PANEL (slide-over) ===== */
    .overlay { position: fixed; inset: 0; background: rgba(0,0,0,0.3); z-index: 100; opacity: 0; pointer-events: none; transition: opacity 0.25s; }
    .overlay.open { opacity: 1; pointer-events: auto; }
    .admin-panel { position: fixed; top: 0; right: -600px; width: 580px; max-width: 95vw; height: 100vh; background: #fff; z-index: 101; transition: right 0.3s; overflow-y: auto; box-shadow: -4px 0 20px rgba(0,0,0,0.15); }
    .admin-panel.open { right: 0; }
    .admin-panel .panel-header { display: flex; align-items: center; justify-content: space-between; padding: 20px 24px; border-bottom: 1px solid #eee; position: sticky; top: 0; background: #fff; z-index: 1; }
    .admin-panel .panel-header h2 { font-size: 1.2rem; margin: 0; }
    .close-btn { background: none; border: none; font-size: 1.5rem; cursor: pointer; color: #888; padding: 4px 8px; border-radius: 4px; }
    .close-btn:hover { background: #f0f0f0; color: #333; }
    .admin-panel .panel-body { padding: 24px; }

    .admin-section { margin-bottom: 28px; border-bottom: 1px solid #eee; padding-bottom: 24px; }
    .admin-section:last-child { border-bottom: none; }
    .admin-section h3 { font-size: 0.95rem; margin-bottom: 12px; color: #333; display: flex; align-items: center; gap: 8px; }
    .admin-section .hint { font-size: 0.78rem; color: #888; margin-bottom: 10px; }

    .tag { display: inline-flex; align-items: center; padding: 4px 10px; border-radius: 12px; font-size: 0.8rem; margin: 3px 4px 3px 0; gap: 4px; }
    .tag button { background: none; border: none; cursor: pointer; font-weight: 700; font-size: 0.9rem; line-height: 1; }
    .tag-green { background: #dcfce7; color: #166534; }
    .tag-green button { color: #166534; }
    .tag-blue { background: #e0e7ff; color: #3730a3; }
    .tag-blue button { color: #3730a3; }
    .tag-purple { background: #f3e8ff; color: #6b21a8; }
    .tag-purple button { color: #6b21a8; }

    .engineer-card { border: 1px solid #e5e7eb; border-radius: 8px; padding: 12px; display: flex; flex-wrap: wrap; gap: 10px; align-items: center; margin-bottom: 8px; font-size: 0.85rem; }
    .engineer-card .eng-name { font-weight: 700; min-width: 120px; }
    .engineer-card .eng-detail { color: #555; }
    .engineer-card .eng-detail span { font-weight: 600; color: #333; }

    .project-card { border: 1px solid #e5e7eb; border-radius: 8px; padding: 14px; margin-bottom: 10px; }
    .project-card h4 { font-size: 0.92rem; margin-bottom: 8px; display: flex; align-items: center; justify-content: space-between; }
    .est-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(140px, 1fr)); gap: 6px; }
    .est-item { background: #f8f9fb; border-radius: 5px; padding: 6px 8px; font-size: 0.82rem; }
    .est-item .est-name { font-weight: 500; margin-bottom: 2px; }
    .est-item input { width: 54px; padding: 2px 4px; border: 1px solid #ddd; border-radius: 4px; font-size: 0.8rem; text-align: center; }
    .est-item .est-actual { font-size: 0.72rem; color: #888; }
    .progress-bar { height: 5px; background: #e5e7eb; border-radius: 3px; margin-top: 3px; overflow: hidden; }
    .progress-bar .fill { height: 100%; border-radius: 3px; }

    .config-input { width: 100%; padding: 8px 11px; border: 1px solid #d0d5dd; border-radius: 6px; font-size: 0.85rem; }
    .config-input.mono { font-family: monospace; }
    .config-hint { font-size: 0.72rem; color: #888; margin-top: 4px; }

    .filters { display: flex; gap: 10px; margin-bottom: 14px; align-items: center; flex-wrap: wrap; }
    .filters select, .filters input { padding: 6px 10px; border: 1px solid #d0d5dd; border-radius: 6px; font-size: 0.82rem; }
  </style>
</head>
<body>
<div class="container">
  <div class="top-bar">
    <h1>Engineer Time Entry</h1>
    <button class="gear-btn" onclick="openAdmin()">&#9881; Admin Settings</button>
  </div>

  <!-- ===== MAIN: TIMESHEET ===== -->
  <div class="card">
    <div style="display:flex;align-items:center;justify-content:space-between;flex-wrap:wrap;gap:12px;margin-bottom:16px">
      <h2 style="margin:0">Weekly Timesheet</h2>
      <div style="display:flex;align-items:center;gap:10px">
        <div id="userBadge" style="display:none;background:#e0e7ff;color:#3730a3;padding:6px 14px;border-radius:20px;font-weight:600;font-size:0.9rem"></div>
        <select id="timesheetEngineer" style="padding:8px 12px;font-size:0.95rem;border:1px solid #d0d5dd;border-radius:6px">
          <option value="">Select engineer...</option>
        </select>
        <button id="switchUserBtn" class="btn btn-secondary btn-sm" style="display:none" onclick="switchUser()">Switch</button>
      </div>
    </div>
    <div class="week-nav">
      <button onclick="changeWeek(-1)">&larr; Prev</button>
      <div class="week-label" id="weekLabel"></div>
      <button onclick="changeWeek(1)">Next &rarr;</button>
      <button class="btn btn-secondary btn-sm" onclick="goToCurrentWeek()">Today</button>
    </div>
    <div id="weekCapacitySummary"></div>
    <div id="timesheetContainer" style="overflow-x:auto"></div>
    <div class="btn-group" style="margin-top:16px">
      <button class="btn btn-primary" onclick="saveTimesheet()">Save Week</button>
      <span id="unsavedBadge" class="unsaved-badge" style="display:none">Unsaved changes</span>
      <span id="lastSaved" style="font-size:0.78rem;color:#888;margin-left:8px"></span>
      <span id="syncStatus" class="sync-status"></span>
    </div>
  </div>


</div>

<!-- ===== ADMIN SLIDE-OVER ===== -->
<div class="overlay" id="adminOverlay" onclick="closeAdmin()"></div>
<div class="admin-panel" id="adminPanel">
  <div class="panel-header">
    <h2>Admin Settings</h2>
    <button class="close-btn" onclick="closeAdmin()">&times;</button>
  </div>
  <div class="panel-body">

    <!-- Engineers -->
    <div class="admin-section">
      <h3>Engineers</h3>
      <div class="form-row" style="margin-bottom:10px">
        <div class="form-group"><label>Name</label><input type="text" id="engName" placeholder="Jane Smith"></div>
        <div class="form-group" style="max-width:90px"><label>Hrs/Wk</label><input type="number" id="engHours" value="40" min="1" max="80"></div>
        <div class="form-group" style="max-width:110px"><label>PTO Accrual</label><input type="number" id="engAccrual" value="3.08" min="0" step="0.01" title="Hours per week"></div>
        <div class="form-group" style="max-width:100px"><label>PTO Start</label><input type="number" id="engPtoBalance" value="0" min="0" step="0.5" title="Starting balance in hours"></div>
        <div class="form-group" style="max-width:130px"><label>Start Date</label><input type="date" id="engStartDate"></div>
        <div class="form-group" style="flex:0"><label>&nbsp;</label><button class="btn btn-primary btn-sm" onclick="addEngineer()">Add</button></div>
      </div>
      <div id="engineerCards"></div>
    </div>

    <!-- Projects -->
    <div class="admin-section">
      <h3>Projects</h3>
      <div class="hint">Create projects first, then add jobs under each project.</div>
      <div class="form-row" style="margin-bottom:10px">
        <div class="form-group"><label>Project Name</label><input type="text" id="newProjectName" placeholder="e.g. Line 4 Upgrade"></div>
        <div class="form-group"><label>Customer</label><input type="text" id="newProjectCustomer" placeholder="e.g. Acme Corp"></div>
        <div class="form-group" style="max-width:140px"><label>Sold Price ($)</label><input type="number" id="newProjectSoldPrice" min="0" step="100" placeholder="0.00"></div>
        <div class="form-group" style="max-width:120px"><label>Status</label>
          <select id="newProjectStatus">
            <option value="green">Green - On Track</option>
            <option value="yellow">Yellow - At Risk</option>
            <option value="red">Red - Behind</option>
          </select>
        </div>
        <div class="form-group" style="flex:0"><label>&nbsp;</label><button class="btn btn-primary btn-sm" onclick="addProject()">Add Project</button></div>
      </div>
      <div id="projectCards"></div>
    </div>

    <!-- Add Job (hidden by default, shown in context) -->
    <div class="admin-section" id="addJobSection" style="display:none">
      <h3>Add Job to: <span id="addJobProjectLabel"></span></h3>
      <div class="form-row" style="margin-bottom:8px">
        <div class="form-group"><label>Job Name</label><input type="text" id="newJobName" placeholder="e.g. Electrical Panel Build"></div>
        <div class="form-group"><label>Job / PO Number</label><input type="text" id="newJobNumber" placeholder="e.g. J-2026-041"></div>
        <div class="form-group" style="max-width:150px"><label>Type</label>
          <select id="newJobType">
            <option value="">Select...</option>
            <option>New Build</option>
            <option>Retrofit</option>
            <option>Service</option>
            <option>R&amp;D</option>
            <option>Other</option>
          </select>
        </div>
      </div>
      <div class="form-row" style="margin-bottom:10px">
        <div class="form-group" style="max-width:150px"><label>Start Date</label><input type="date" id="newJobStart"></div>
        <div class="form-group" style="max-width:150px"><label>Target Completion</label><input type="date" id="newJobEnd"></div>
        <div class="form-group" style="max-width:150px"><label>Ship Date</label><input type="date" id="newJobShip"></div>
        <div class="form-group" style="flex:0"><label>&nbsp;</label><button class="btn btn-primary btn-sm" onclick="addJob()">Add Job</button></div>
        <div class="form-group" style="flex:0"><label>&nbsp;</label><button class="btn btn-secondary btn-sm" onclick="cancelAddJob()">Cancel</button></div>
      </div>
    </div>

    <!-- Work Categories -->
    <div class="admin-section">
      <h3>Work Categories</h3>
      <div class="hint">Types of work engineers log against (applies to all projects).</div>
      <div class="form-row" style="margin-bottom:10px">
        <div class="form-group"><label>Category Name</label><input type="text" id="newCategory" placeholder="e.g. Design, Assembly"></div>
        <div class="form-group" style="flex:0"><label>&nbsp;</label><button class="btn btn-primary btn-sm" onclick="addCategory()">Add</button></div>
      </div>
      <div id="categoryList"></div>
    </div>

    <!-- Company Holidays -->
    <div class="admin-section">
      <h3>Company Holidays</h3>
      <div class="hint">Each holiday removes one day from all engineers' weekly capacity.</div>
      <div class="form-row" style="margin-bottom:10px">
        <div class="form-group" style="max-width:150px"><label>Date</label><input type="date" id="holidayDate"></div>
        <div class="form-group"><label>Name</label><input type="text" id="holidayName" placeholder="e.g. Independence Day"></div>
        <div class="form-group" style="flex:0"><label>&nbsp;</label><button class="btn btn-primary btn-sm" onclick="addHoliday()">Add</button></div>
      </div>
      <div id="holidayList"></div>
    </div>

    <!-- General Settings -->
    <div class="admin-section">
      <h3>General</h3>
      <div style="margin-bottom:12px">
        <label style="font-size:0.82rem;font-weight:600;color:#555;display:block;margin-bottom:4px">Hours per Day</label>
        <input type="number" id="hoursPerDay" value="8" min="1" max="12" step="0.5" class="config-input" style="max-width:100px" onchange="saveHoursPerDay()">
        <div class="config-hint">Used for PTO and holiday deductions.</div>
      </div>
      <div style="margin-bottom:12px">
        <label style="font-size:0.82rem;font-weight:600;color:#555;display:block;margin-bottom:4px">Weighted Hourly Cost ($/hr)</label>
        <input type="number" id="costRate" value="88" min="0" step="0.5" class="config-input" style="max-width:120px" onchange="saveCostRate()">
        <div class="config-hint">Company-wide blended cost per engineering hour. Used for project cost calculations.</div>
      </div>
      <div>
        <label style="font-size:0.82rem;font-weight:600;color:#555;display:block;margin-bottom:4px">Power Automate Flow URL</label>
        <input type="text" id="flowUrl" class="config-input mono" placeholder="https://prod-xx.westus.logic.azure.com:443/workflows/..." oninput="saveFlowUrl()">
        <div class="config-hint">Paste the HTTP POST URL from your Power Automate flow for SharePoint sync.</div>
      </div>
    </div>

    <!-- All Entries -->
    <div class="admin-section">
      <h3>All Entries</h3>
      <div class="filters">
        <label style="font-size:0.82rem;font-weight:600">Filter:</label>
        <select id="filterEngineer"><option value="">All Engineers</option></select>
        <select id="filterProject"><option value="">All Projects</option></select>
        <select id="filterCategory"><option value="">All Categories</option></select>
        <input type="date" id="filterFrom" title="From">
        <input type="date" id="filterTo" title="To">
        <button class="btn btn-secondary btn-sm" onclick="clearFilters()">Clear</button>
      </div>
      <div class="summary" id="summary"></div>
      <div style="max-height:400px;overflow-y:auto">
        <table>
          <thead><tr><th>Date</th><th>Engineer</th><th>Project / Job</th><th>Category</th><th>Hours</th><th></th></tr></thead>
          <tbody id="logBody"></tbody>
        </table>
      </div>
      <div class="btn-group" style="margin-top:12px">
        <button class="btn btn-secondary btn-sm" onclick="exportCSV()">Export CSV</button>
      </div>
    </div>

  </div>
</div>

<div class="toast" id="toast"></div>

<script>
const KEYS = {
  entries:'timeEntries', engineers:'engineerProfiles', projects:'projectProfiles',
  holidays:'companyHolidays', ptoUsage:'ptoUsage', travelDays:'travelDays',
  categories:'workCategories', weeklyNotes:'weeklyNotes', flowUrl:'powerAutomateFlowUrl', hoursPerDay:'hoursPerDay'
};
function load(k,fb){try{return JSON.parse(localStorage.getItem(k))||fb}catch{return fb}}
function persist(k,d){localStorage.setItem(k,JSON.stringify(d))}

let entries=load(KEYS.entries,[]);
let engineers=load(KEYS.engineers,[]);
let projects=load(KEYS.projects,[]);
let holidays=load(KEYS.holidays,[]);
let ptoUsage=load(KEYS.ptoUsage,[]);
let travelDays=load(KEYS.travelDays,[]);
let weeklyNotes=load(KEYS.weeklyNotes,[]);
let categories=load(KEYS.categories,['Design','Assembly','Shop Support']);

// Migrate: old flat string projects → {name, customer, jobs:[]}
if(projects.length>0&&typeof projects[0]==='string'){projects=projects.map(n=>({name:n,customer:'',jobs:[]}));persist(KEYS.projects,projects)}
// Migrate: old project objects without jobs array
projects.forEach(p=>{if(!p.jobs){p.jobs=[{name:p.name,jobNumber:p.jobNumber||'',jobType:p.projectType||'',startDate:p.startDate||'',targetDate:p.targetDate||'',shipDate:p.shipDate||'',estimates:p.estimates||{}}];delete p.jobNumber;delete p.projectType;delete p.startDate;delete p.targetDate;delete p.shipDate;delete p.estimates}if(!p.customer)p.customer=''});
persist(KEYS.projects,projects);
entries.forEach(e=>{if(!e.category)e.category='General';if(!e.job)e.job=e.project});

const $=id=>document.getElementById(id);
let currentWeekStart=getSunday(new Date());
let timesheetDirty=false;
let timesheetRows=[]; // [{project,job,category}]

function toast(m){const t=$('toast');t.textContent=m;t.classList.add('show');setTimeout(()=>t.classList.remove('show'),2500)}

// Admin panel
function openAdmin(){$('adminOverlay').classList.add('open');$('adminPanel').classList.add('open');renderEngineers();renderProjectCards();renderCategories();renderHolidays();populateDropdowns();renderLog()}
function closeAdmin(){$('adminOverlay').classList.remove('open');$('adminPanel').classList.remove('open');populateDropdowns();renderTimesheet()}

// Date utils
function getSunday(d){const dt=new Date(d);dt.setDate(dt.getDate()-dt.getDay());dt.setHours(0,0,0,0);return dt}
function dateStr(d){return`${d.getFullYear()}-${String(d.getMonth()+1).padStart(2,'0')}-${String(d.getDate()).padStart(2,'0')}`}
function getWeekDates(){const r=[];for(let i=0;i<7;i++){const d=new Date(currentWeekStart);d.setDate(d.getDate()+i);r.push(d)}return r}
function formatShortDate(d){const days=['Sun','Mon','Tue','Wed','Thu','Fri','Sat'];const mo=['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];return`${days[d.getDay()]}<br>${mo[d.getMonth()]} ${d.getDate()}`}
function formatDate(d){const[y,m,day]=d.split('-');return`${m}/${day}/${y}`}
function esc(s){const d=document.createElement('div');d.textContent=s;return d.innerHTML}
function escAttr(s){return s.replace(/'/g,'&#39;').replace(/"/g,'&quot;')}
function getHoursPerDay(){return parseFloat(localStorage.getItem(KEYS.hoursPerDay))||8}
function saveHoursPerDay(){localStorage.setItem(KEYS.hoursPerDay,$('hoursPerDay').value)}
function saveFlowUrl(){localStorage.setItem(KEYS.flowUrl,$('flowUrl').value.trim())}
function getCostRate(){return parseFloat(localStorage.getItem('costRate'))||88}
function saveCostRate(){localStorage.setItem('costRate',$('costRate').value)}

// PTO
function getPtoBalance(eng,asOf){const s=new Date(eng.ptoStartDate),e=new Date(asOf);if(e<s)return eng.ptoBalance;const w=Math.floor((e-s)/(7*864e5));const a=eng.ptoBalance+w*eng.ptoAccrual;const u=ptoUsage.filter(p=>p.engineer===eng.name&&p.date<=asOf).reduce((s,p)=>s+p.hours,0);return Math.max(0,a-u)}
function getWeekPtoHours(n,wds){return ptoUsage.filter(p=>p.engineer===n&&wds.includes(p.date)).reduce((s,p)=>s+p.hours,0)}
function getWeekTravelHours(n,wds){return travelDays.filter(t=>t.engineer===n&&wds.includes(t.date)).reduce((s,t)=>s+t.hours,0)}
function getWeekHolidays(wds){return holidays.filter(h=>wds.includes(h.date))}

// ===== ENGINEERS =====
function addEngineer(){
  const name=$('engName').value.trim();if(!name)return;
  if(engineers.find(e=>e.name===name)){toast('Already exists');return}
  engineers.push({name,weeklyHours:parseFloat($('engHours').value)||40,ptoAccrual:parseFloat($('engAccrual').value)||0,ptoBalance:parseFloat($('engPtoBalance').value)||0,ptoStartDate:$('engStartDate').value||dateStr(new Date())});
  engineers.sort((a,b)=>a.name.localeCompare(b.name));persist(KEYS.engineers,engineers);
  $('engName').value='';$('engPtoBalance').value='0';renderEngineers();toast('Engineer added');
}
function removeEngineer(n){if(!confirm(`Remove ${n}?`))return;engineers=engineers.filter(e=>e.name!==n);persist(KEYS.engineers,engineers);renderEngineers()}
function renderEngineers(){
  const c=$('engineerCards');
  if(!engineers.length){c.innerHTML='<div class="empty-state">No engineers added.</div>';return}
  const today=dateStr(new Date());
  c.innerHTML=engineers.map(eng=>{
    const bal=getPtoBalance(eng,today);
    return`<div class="engineer-card"><div class="eng-name">${esc(eng.name)}</div>
      <div class="eng-detail">${eng.weeklyHours}h/wk</div>
      <div class="eng-detail">Accrual: <span>${eng.ptoAccrual}h/wk</span></div>
      <div class="eng-detail">PTO: <span>${bal.toFixed(1)}h</span></div>
      <button class="btn btn-danger btn-sm" onclick="removeEngineer('${escAttr(eng.name)}')">Remove</button></div>`
  }).join('');
}

// ===== HOLIDAYS =====
function addHoliday(){const d=$('holidayDate').value,n=$('holidayName').value.trim();if(!d||!n)return;if(holidays.find(h=>h.date===d)){toast('Date taken');return}holidays.push({date:d,name:n});holidays.sort((a,b)=>a.date.localeCompare(b.date));persist(KEYS.holidays,holidays);$('holidayDate').value='';$('holidayName').value='';renderHolidays();toast('Holiday added')}
function removeHoliday(d){holidays=holidays.filter(h=>h.date!==d);persist(KEYS.holidays,holidays);renderHolidays()}
function renderHolidays(){const el=$('holidayList');if(!holidays.length){el.innerHTML='<div class="empty-state" style="padding:12px">None added.</div>';return}el.innerHTML=holidays.map(h=>`<span class="tag tag-green">${formatDate(h.date)} — ${esc(h.name)}<button onclick="removeHoliday('${h.date}')">&times;</button></span>`).join('')}

// ===== CATEGORIES =====
function addCategory(){const n=$('newCategory').value.trim();if(!n)return;if(categories.includes(n)){toast('Exists');return}categories.push(n);persist(KEYS.categories,categories);$('newCategory').value='';renderCategories();toast('Category added')}
function removeCategory(n){categories=categories.filter(c=>c!==n);persist(KEYS.categories,categories);renderCategories()}
function renderCategories(){const el=$('categoryList');if(!categories.length){el.innerHTML='<div class="empty-state" style="padding:12px">None added.</div>';return}el.innerHTML=categories.map(c=>`<span class="tag tag-blue">${esc(c)}<button onclick="removeCategory('${escAttr(c)}')">&times;</button></span>`).join('')}

// ===== PROJECTS & JOBS =====
let addJobTarget=null;

function addProject(){
  const n=$('newProjectName').value.trim(),cust=$('newProjectCustomer').value.trim();
  if(!n)return;
  if(projects.find(p=>p.name===n)){toast('Exists');return}
  projects.push({name:n,customer:cust,soldPrice:parseFloat($('newProjectSoldPrice').value)||0,status:$('newProjectStatus').value||'green',jobs:[]});
  $('newProjectSoldPrice').value='';
  projects.sort((a,b)=>a.name.localeCompare(b.name));persist(KEYS.projects,projects);
  $('newProjectName').value='';$('newProjectCustomer').value='';
  renderProjectCards();toast('Project added');
}
function removeProject(n){if(!confirm(`Remove project "${n}" and all its jobs?`))return;projects=projects.filter(p=>p.name!==n);persist(KEYS.projects,projects);renderProjectCards()}
function updateProjectStatus(pn,v){const p=projects.find(x=>x.name===pn);if(!p)return;p.status=v;persist(KEYS.projects,projects);renderProjectCards()}

function showAddJob(projName){
  addJobTarget=projName;
  $('addJobProjectLabel').textContent=projName;
  $('addJobSection').style.display='block';
  $('newJobName').value='';$('newJobNumber').value='';$('newJobType').value='';
  $('newJobStart').value='';$('newJobEnd').value='';$('newJobShip').value='';
  $('newJobName').focus();
}
function cancelAddJob(){$('addJobSection').style.display='none';addJobTarget=null}

function addJob(){
  if(!addJobTarget)return;
  const proj=projects.find(p=>p.name===addJobTarget);if(!proj)return;
  const name=$('newJobName').value.trim();if(!name)return;
  if(proj.jobs.find(j=>j.name===name)){toast('Job name exists in this project');return}
  const est={};categories.forEach(c=>{est[c]=0});
  proj.jobs.push({
    name,jobNumber:$('newJobNumber').value.trim(),jobType:$('newJobType').value,
    startDate:$('newJobStart').value,targetDate:$('newJobEnd').value,shipDate:$('newJobShip').value,
    estimates:est
  });
  persist(KEYS.projects,projects);
  cancelAddJob();renderProjectCards();toast('Job added');
}
function removeJob(projName,jobName){
  if(!confirm(`Remove job "${jobName}"?`))return;
  const proj=projects.find(p=>p.name===projName);if(!proj)return;
  proj.jobs=proj.jobs.filter(j=>j.name!==jobName);
  persist(KEYS.projects,projects);renderProjectCards();
}
function updateJobPct(projName,jobName,v){
  const proj=projects.find(p=>p.name===projName);if(!proj)return;
  const job=proj.jobs.find(j=>j.name===jobName);if(!job)return;
  job.percentComplete=Math.min(100,Math.max(0,parseInt(v)||0));persist(KEYS.projects,projects);
}
function updateEstimate(projName,jobName,cat,v){
  const proj=projects.find(p=>p.name===projName);if(!proj)return;
  const job=proj.jobs.find(j=>j.name===jobName);if(!job)return;
  job.estimates[cat]=parseFloat(v)||0;persist(KEYS.projects,projects);
}
function getActualHours(projName,jobName,cat){
  return entries.filter(e=>e.project===projName&&e.job===jobName&&e.category===cat).reduce((s,e)=>s+e.hours,0);
}
function getJobActualTotal(projName,jobName){
  return entries.filter(e=>e.project===projName&&e.job===jobName).reduce((s,e)=>s+e.hours,0);
}

function renderProjectCards(){
  const el=$('projectCards');
  if(!projects.length){el.innerHTML='<div class="empty-state" style="padding:12px">No projects.</div>';return}
  el.innerHTML=projects.map(proj=>{
    const projActual=entries.filter(e=>e.project===proj.name).reduce((s,e)=>s+e.hours,0);
    const projEst=proj.jobs.reduce((s,j)=>{categories.forEach(c=>{s+=(j.estimates[c]||0)});return s},0);

    let jobsHtml='';
    if(!proj.jobs.length){
      jobsHtml='<div style="padding:8px 0;color:#888;font-size:0.82rem">No jobs yet. Add one below.</div>';
    } else {
      jobsHtml=proj.jobs.map(job=>{
        categories.forEach(c=>{if(job.estimates[c]===undefined)job.estimates[c]=0});
        const jEst=Object.values(job.estimates).reduce((a,b)=>a+b,0);
        const jAct=getJobActualTotal(proj.name,job.name);
        const jPct=jEst>0?Math.min(100,Math.round(jAct/jEst*100)):(jAct>0?100:0);
        const jBar=jPct>100?'red':jPct>80?'yellow':'green';

        const chips=[];
        if(job.jobNumber)chips.push(`<span class="tag tag-purple">${esc(job.jobNumber)}</span>`);
        if(job.jobType)chips.push(`<span class="tag tag-green">${esc(job.jobType)}</span>`);
        const dates=[];
        if(job.startDate)dates.push('Start: '+formatDate(job.startDate));
        if(job.targetDate)dates.push('Target: '+formatDate(job.targetDate));
        if(job.shipDate)dates.push('Ship: '+formatDate(job.shipDate));
        if(dates.length)chips.push(`<span style="font-size:0.75rem;color:#888">${dates.join(' | ')}</span>`);

        let catHtml='<div class="est-grid">';
        categories.forEach(c=>{
          const est=job.estimates[c]||0;const act=getActualHours(proj.name,job.name,c);
          const pct=est>0?Math.min(100,Math.round(act/est*100)):(act>0?100:0);
          const bc=pct>100?'red':pct>80?'yellow':'green';
          catHtml+=`<div class="est-item"><div class="est-name">${esc(c)}</div>
            <div style="display:flex;align-items:center;gap:4px"><input type="number" min="0" step="1" value="${est}" onchange="updateEstimate('${escAttr(proj.name)}','${escAttr(job.name)}','${escAttr(c)}',this.value)"><span class="est-actual">${act}h</span></div>
            <div class="progress-bar"><div class="fill ${bc}" style="width:${pct}%"></div></div></div>`;
        });
        catHtml+='</div>';

        const pctComplete=job.percentComplete||0;

        return`<div style="border:1px solid #e5e7eb;border-radius:6px;padding:10px;margin-bottom:8px;margin-left:12px">
          <div style="display:flex;justify-content:space-between;align-items:center;margin-bottom:4px">
            <strong style="font-size:0.9rem">${esc(job.name)}</strong>
            <div style="display:flex;align-items:center;gap:8px">
              <span style="font-size:0.78rem;color:#555">${jAct}/${jEst}h</span>
              <div class="progress-bar" style="width:80px"><div class="fill ${jBar}" style="width:${jPct}%"></div></div>
              <label style="font-size:0.72rem;color:#888;display:flex;align-items:center;gap:3px">Complete: <input type="number" min="0" max="100" step="5" value="${pctComplete}" style="width:48px;padding:2px 3px;border:1px solid #ddd;border-radius:4px;font-size:0.78rem;text-align:center" onchange="updateJobPct('${escAttr(proj.name)}','${escAttr(job.name)}',this.value)">%</label>
              <button class="btn btn-danger btn-sm" onclick="removeJob('${escAttr(proj.name)}','${escAttr(job.name)}')">Remove</button>
            </div>
          </div>
          ${chips.length?'<div style="margin-bottom:6px;display:flex;gap:4px;align-items:center;flex-wrap:wrap">'+chips.join('')+'</div>':''}
          ${catHtml}
        </div>`;
      }).join('');
    }

    const st=proj.status||'green';
    const stColors={green:'#22c55e',yellow:'#eab308',red:'#ef4444'};
    const stLabels={green:'On Track',yellow:'At Risk',red:'Behind'};
    const projCost=entries.filter(e=>e.project===proj.name).reduce((s,e)=>s+e.hours*getCostRate(),0);

    return`<div class="project-card">
      <h4>
        <div style="display:flex;align-items:center;gap:8px">
          <span style="width:12px;height:12px;border-radius:50%;background:${stColors[st]};display:inline-block;flex-shrink:0"></span>
          ${esc(proj.name)}${proj.customer?' <span style="font-weight:400;font-size:0.82rem;color:#666">— '+esc(proj.customer)+'</span>':''}
        </div>
        <div style="display:flex;gap:6px">
          <select style="padding:3px 6px;border:1px solid #ddd;border-radius:4px;font-size:0.75rem" onchange="updateProjectStatus('${escAttr(proj.name)}',this.value)">
            <option value="green" ${st==='green'?'selected':''}>Green</option>
            <option value="yellow" ${st==='yellow'?'selected':''}>Yellow</option>
            <option value="red" ${st==='red'?'selected':''}>Red</option>
          </select>
          <button class="btn btn-secondary btn-sm" onclick="showAddJob('${escAttr(proj.name)}')">+ Add Job</button>
          <button class="btn btn-danger btn-sm" onclick="removeProject('${escAttr(proj.name)}')">Remove</button>
        </div>
      </h4>
      <div style="font-size:0.82rem;color:#555;margin-bottom:8px">
        ${proj.jobs.length} job${proj.jobs.length!==1?'s':''} | Est: ${projEst}h | Actual: ${projActual}h | Cost: $${projCost.toFixed(0)}
        ${(proj.soldPrice||0)>0?` | Sold: $${proj.soldPrice.toLocaleString()} | Margin: $${(proj.soldPrice-projCost).toLocaleString(undefined,{maximumFractionDigits:0})} (${Math.round((proj.soldPrice-projCost)/proj.soldPrice*100)}%)`:''}
      </div>
      ${jobsHtml}
    </div>`;
  }).join('');
}

// ===== TIMESHEET =====
function changeWeek(dir){if(timesheetDirty&&!confirm('Unsaved changes. Discard?'))return;currentWeekStart.setDate(currentWeekStart.getDate()+dir*7);timesheetDirty=false;timesheetRows=[];renderTimesheet()}
function goToCurrentWeek(){if(timesheetDirty&&!confirm('Unsaved changes. Discard?'))return;currentWeekStart=getSunday(new Date());timesheetDirty=false;timesheetRows=[];renderTimesheet()}
function rowKey(p,j,c){return`${p}|||${j}|||${c}`}

function renderTimesheet(){
  const engName=$('timesheetEngineer').value;
  const weekDates=getWeekDates(),todayStr=dateStr(new Date()),wds=weekDates.map(dateStr);
  const sL=weekDates[0].toLocaleDateString('en-US',{month:'short',day:'numeric'});
  const eL=weekDates[6].toLocaleDateString('en-US',{month:'short',day:'numeric',year:'numeric'});
  $('weekLabel').textContent=`${sL} — ${eL}`;

  if(!engName){$('timesheetContainer').innerHTML='<div class="empty-state">Select an engineer to enter time.</div>';$('weekCapacitySummary').innerHTML='';return}
  const eng=engineers.find(e=>e.name===engName);
  if(!eng){$('timesheetContainer').innerHTML='<div class="empty-state">Engineer not found. Add them in Admin Settings.</div>';return}

  const hpd=getHoursPerDay(),weekHols=getWeekHolidays(wds),holDates=new Set(weekHols.map(h=>h.date)),holHrs=weekHols.length*hpd;
  const ptoHrs=getWeekPtoHours(engName,wds),travelHrs=getWeekTravelHours(engName,wds);
  const baseCap=eng.weeklyHours,availCap=Math.max(0,baseCap-holHrs-ptoHrs-travelHrs);
  const weekEntries=entries.filter(e=>e.engineer===engName&&wds.includes(e.date));
  const loggedHrs=weekEntries.reduce((s,e)=>s+e.hours,0);
  const utilPct=availCap>0?Math.round(loggedHrs/availCap*100):0;
  const ptoBal=getPtoBalance(eng,wds[6]);
  const barCls=utilPct>100?'red':utilPct>80?'yellow':'green';

  $('weekCapacitySummary').innerHTML=`<div class="summary">
    <div class="stat"><div class="label">Base</div><div class="value">${baseCap}h</div></div>
    <div class="stat${holHrs?' warn':''}"><div class="label">Holidays</div><div class="value">-${holHrs}h</div></div>
    <div class="stat${ptoHrs?' warn':''}"><div class="label">PTO</div><div class="value">-${ptoHrs}h</div></div>
    <div class="stat${travelHrs?' warn':''}"><div class="label">Travel</div><div class="value">-${travelHrs}h</div></div>
    <div class="stat good"><div class="label">Available</div><div class="value">${availCap}h</div></div>
    <div class="stat"><div class="label">Logged</div><div class="value">${loggedHrs}h</div><div class="capacity-bar"><div class="fill ${barCls}" style="width:${Math.min(100,utilPct)}%"></div></div></div>
    <div class="stat"><div class="label">PTO Balance</div><div class="value">${ptoBal.toFixed(1)}h</div></div></div>`;

  // Discover existing rows from saved entries
  const existingRows=[];
  weekEntries.forEach(e=>{const k=rowKey(e.project,e.job,e.category);if(!existingRows.find(r=>rowKey(r.project,r.job,r.category)===k))existingRows.push({project:e.project,job:e.job,category:e.category})});
  existingRows.forEach(r=>{if(!timesheetRows.find(tr=>rowKey(tr.project,tr.job,tr.category)===rowKey(r.project,r.job,r.category)))timesheetRows.push(r)});

  const hMap={};
  weekEntries.forEach(e=>{hMap[`${e.project}|||${e.job}|||${e.category}|||${e.date}`]=e.hours});
  const ptoDayMap={};ptoUsage.filter(p=>p.engineer===engName&&wds.includes(p.date)).forEach(p=>{ptoDayMap[p.date]=p.hours});
  const travelMap={};travelDays.filter(t=>t.engineer===engName&&wds.includes(t.date)).forEach(t=>{travelMap[t.date]=t.hours});

  let html='<table class="timesheet"><thead><tr><th>Project / Job / Category</th>';
  weekDates.forEach(d=>{const ds=dateStr(d);html+=`<th class="${ds===todayStr?'today':''}" ${holDates.has(ds)?'style="background:#dcfce7"':''}>${formatShortDate(d)}${holDates.has(ds)?'<br>🏖':''}</th>`});
  html+='<th>Total</th></tr></thead><tbody>';

  if(weekHols.length){html+='<tr class="holiday-row"><td>Holidays</td>';weekDates.forEach(d=>{const h=weekHols.find(x=>x.date===dateStr(d));html+=`<td>${h?esc(h.name):''}</td>`});html+=`<td class="row-total">-${holHrs}h</td></tr>`}

  html+='<tr class="pto-row"><td>PTO</td>';
  weekDates.forEach(d=>{const ds=dateStr(d),v=ptoDayMap[ds]||'';html+=`<td><input type="number" min="0" max="${hpd}" step="${hpd/2}" value="${v}" data-type="pto" data-date="${ds}" onchange="markDirty()" class="${v?'has-value':''}"></td>`});
  html+=`<td class="row-total" id="rowTotal_pto">${ptoHrs||''}</td></tr>`;

  html+='<tr class="travel-row"><td>Travel</td>';
  weekDates.forEach(d=>{const ds=dateStr(d),v=travelMap[ds]||'';html+=`<td><input type="number" min="0" max="${hpd}" step="${hpd/2}" value="${v}" data-type="travel" data-date="${ds}" onchange="markDirty()" class="${v?'has-value':''}"></td>`});
  html+=`<td class="row-total" id="rowTotal_travel">${travelHrs||''}</td></tr>`;

  html+=`<tr><td colspan="9" style="border-bottom:2px solid #4a6cf7;padding:0"></td></tr>`;

  // Group rows: project → job → category
  const grouped={};
  timesheetRows.forEach(r=>{
    if(!grouped[r.project])grouped[r.project]={};
    if(!grouped[r.project][r.job])grouped[r.project][r.job]=[];
    grouped[r.project][r.job].push(r.category);
  });

  if(!Object.keys(grouped).length)html+=`<tr><td colspan="9" class="empty-state">Add a project/job/category row below.</td></tr>`;

  Object.keys(grouped).sort().forEach(proj=>{
    // Project header
    let projTotal=0;
    timesheetRows.filter(r=>r.project===proj).forEach(r=>weekDates.forEach(d=>{projTotal+=hMap[`${proj}|||${r.job}|||${r.category}|||${dateStr(d)}`]||0}));
    const po=projects.find(p=>p.name===proj);
    html+=`<tr class="project-header"><td colspan="8">${esc(proj)}${po&&po.customer?' <span style="font-weight:400;font-size:0.78rem;color:#6366f1">— '+esc(po.customer)+'</span>':''}</td><td class="row-total">${projTotal||''}</td></tr>`;

    Object.keys(grouped[proj]).sort().forEach(job=>{
      const cats=grouped[proj][job];
      // Job sub-header
      let jobTotal=0;
      cats.forEach(cat=>weekDates.forEach(d=>{jobTotal+=hMap[`${proj}|||${job}|||${cat}|||${dateStr(d)}`]||0}));
      const jobObj=po?po.jobs.find(j=>j.name===job):null;
      const jNum=jobObj&&jobObj.jobNumber?` (${jobObj.jobNumber})`:'';
      const jEst=jobObj?Object.values(jobObj.estimates||{}).reduce((a,b)=>a+b,0):0;
      const jPctC=jobObj?(jobObj.percentComplete||0):0;
      const noteKey=`${engName}|||${proj}|||${job}|||${wds[0]}`;
      const existingNote=weeklyNotes.find(n=>n.key===noteKey);
      const noteVal=existingNote?existingNote.note:'';
      html+=`<tr><td style="padding-left:16px;font-weight:600;font-size:0.84rem;color:#4338ca;background:#eef2ff" colspan="8">
        ${esc(job)}${esc(jNum)}${jEst?' <span style="font-weight:400;font-size:0.72rem;color:#888">(Est: '+jEst+'h | '+jPctC+'% complete)</span>':''}
      </td><td class="row-total" style="background:#eef2ff">${jobTotal||''}</td></tr>`;
      html+=`<tr><td colspan="9" style="padding:2px 8px 6px 24px;border-bottom:none;background:#f8f9ff">
        <input type="text" placeholder="Weekly note for this job..." value="${escAttr(noteVal)}" data-notekey="${escAttr(noteKey)}" data-type="note" onchange="markDirty()" style="width:100%;padding:4px 8px;border:1px solid #e0e0e0;border-radius:4px;font-size:0.78rem;color:#555;background:#fff">
      </td></tr>`;

      cats.sort().forEach(cat=>{
        const rk=rowKey(proj,job,cat);let rt=0;
        const cEst=jobObj?(jobObj.estimates[cat]||0):0;
        const cAct=getActualHours(proj,job,cat);
        html+=`<tr class="category-row"><td>${esc(cat)}${cEst?` <span style="color:#888;font-size:0.72rem">(${cAct}/${cEst}h)</span>`:''} <button class="remove-row-btn" onclick="removeTimesheetRow('${escAttr(proj)}','${escAttr(job)}','${escAttr(cat)}')">&times;</button></td>`;
        weekDates.forEach(d=>{const ds=dateStr(d),v=hMap[`${proj}|||${job}|||${cat}|||${ds}`]||'';if(v)rt+=v;
          html+=`<td><input type="number" min="0" max="24" step="0.25" value="${v}" data-project="${escAttr(proj)}" data-job="${escAttr(job)}" data-category="${escAttr(cat)}" data-date="${ds}" data-type="project" onchange="markDirty()" class="${v?'has-value':''}"></td>`});
        html+=`<td class="row-total" id="rt_${escAttr(rk)}">${rt||''}</td></tr>`;
      });
    });
  });

  html+='</tbody><tfoot><tr><td><strong>Daily Total</strong></td>';
  weekDates.forEach(d=>{const ds=dateStr(d);let dt=0;timesheetRows.forEach(r=>{dt+=hMap[`${r.project}|||${r.job}|||${r.category}|||${ds}`]||0});html+=`<td id="dayTotal_${ds}"><strong>${dt||''}</strong></td>`});
  html+=`<td class="row-total"><strong>${loggedHrs||''}</strong></td></tr></tfoot></table>`;

  // Add row controls: project → job (filtered) → category
  html+=`<div style="margin-top:12px;display:flex;gap:8px;align-items:center;flex-wrap:wrap">
    <select id="addRowProject" style="padding:6px 10px;border:1px solid #d0d5dd;border-radius:6px;font-size:0.85rem" onchange="onAddRowProjectChange()"><option value="">Project...</option>`;
  projects.forEach(p=>{html+=`<option value="${escAttr(p.name)}">${esc(p.name)}</option>`});
  html+=`</select>
    <select id="addRowJob" style="padding:6px 10px;border:1px solid #d0d5dd;border-radius:6px;font-size:0.85rem"><option value="">Job...</option></select>
    <select id="addRowCategory" style="padding:6px 10px;border:1px solid #d0d5dd;border-radius:6px;font-size:0.85rem"><option value="">Category...</option>`;
  categories.forEach(c=>{html+=`<option value="${escAttr(c)}">${esc(c)}</option>`});
  html+=`</select>
    <button class="btn btn-secondary btn-sm" onclick="addTimesheetRow()">Add Row</button></div>`;

  $('timesheetContainer').innerHTML=html;
  $('unsavedBadge').style.display=timesheetDirty?'inline-block':'none';

  // Show last saved timestamp
  const saveKey=`lastSaved_${engName}_${wds[0]}`;
  const lastSaved=localStorage.getItem(saveKey);
  if(lastSaved){
    const d=new Date(lastSaved);
    const day=d.toLocaleDateString('en-US',{weekday:'long',month:'numeric',day:'numeric'});
    const time=d.toLocaleTimeString('en-US',{hour:'numeric',minute:'2-digit'});
    $('lastSaved').textContent=`Last saved: ${day} at ${time}`;
  } else {
    $('lastSaved').textContent='Not yet submitted this week';
  }
}

function onAddRowProjectChange(){
  const projName=document.getElementById('addRowProject')?.value;
  const jobSel=document.getElementById('addRowJob');
  jobSel.innerHTML='<option value="">Job...</option>';
  if(!projName)return;
  const proj=projects.find(p=>p.name===projName);
  if(!proj)return;
  proj.jobs.forEach(j=>{const lbl=j.jobNumber?`${j.name} (${j.jobNumber})`:j.name;jobSel.innerHTML+=`<option value="${escAttr(j.name)}">${esc(lbl)}</option>`});
}

function markDirty(){timesheetDirty=true;$('unsavedBadge').style.display='inline-block';updateTimesheetTotals()}

function updateTimesheetTotals(){
  const weekDates=getWeekDates(),c=$('timesheetContainer');
  const pi=c.querySelectorAll('input[data-type="project"]'),pti=c.querySelectorAll('input[data-type="pto"]'),tri=c.querySelectorAll('input[data-type="travel"]');
  const dt={},rkt={};let ptoT=0,travT=0;
  pi.forEach(i=>{const v=parseFloat(i.value)||0;dt[i.dataset.date]=(dt[i.dataset.date]||0)+v;const rk=rowKey(i.dataset.project,i.dataset.job,i.dataset.category);rkt[rk]=(rkt[rk]||0)+v;i.classList.toggle('has-value',v>0)});
  pti.forEach(i=>{const v=parseFloat(i.value)||0;ptoT+=v;i.classList.toggle('has-value',v>0)});
  tri.forEach(i=>{const v=parseFloat(i.value)||0;travT+=v;i.classList.toggle('has-value',v>0)});
  weekDates.forEach(d=>{const el=document.getElementById('dayTotal_'+dateStr(d));if(el)el.innerHTML=`<strong>${dt[dateStr(d)]||''}</strong>`});
  Object.keys(rkt).forEach(rk=>{const el=document.getElementById('rt_'+rk);if(el)el.textContent=rkt[rk]||''});
  const ptEl=document.getElementById('rowTotal_pto');if(ptEl)ptEl.textContent=ptoT||'';
  const trEl=document.getElementById('rowTotal_travel');if(trEl)trEl.textContent=travT||'';
  const grand=Object.values(dt).reduce((a,b)=>a+b,0);
  const fc=c.querySelectorAll('tfoot .row-total');if(fc.length)fc[0].innerHTML=`<strong>${grand||''}</strong>`;
}

function addTimesheetRow(){
  const p=document.getElementById('addRowProject')?.value;
  const j=document.getElementById('addRowJob')?.value;
  const c=document.getElementById('addRowCategory')?.value;
  if(!p||!j||!c){toast('Select project, job, and category');return}
  if(timesheetRows.find(r=>r.project===p&&r.job===j&&r.category===c)){toast('Row exists');return}
  timesheetRows.push({project:p,job:j,category:c});renderTimesheet();
}
function removeTimesheetRow(p,j,c){timesheetRows=timesheetRows.filter(r=>!(r.project===p&&r.job===j&&r.category===c));markDirty();renderTimesheet()}

function saveTimesheet(){
  const engName=$('timesheetEngineer').value;if(!engName){toast('Select an engineer');return}
  const wds=getWeekDates().map(dateStr),c=$('timesheetContainer');
  entries=entries.filter(e=>!(e.engineer===engName&&wds.includes(e.date)));
  c.querySelectorAll('input[data-type="project"]').forEach(i=>{const v=parseFloat(i.value);if(v>0)entries.push({engineer:engName,project:i.dataset.project,job:i.dataset.job,category:i.dataset.category,hours:v,date:i.dataset.date})});
  persist(KEYS.entries,entries);
  ptoUsage=ptoUsage.filter(p=>!(p.engineer===engName&&wds.includes(p.date)));
  c.querySelectorAll('input[data-type="pto"]').forEach(i=>{const v=parseFloat(i.value);if(v>0)ptoUsage.push({engineer:engName,date:i.dataset.date,hours:v})});
  persist(KEYS.ptoUsage,ptoUsage);
  travelDays=travelDays.filter(t=>!(t.engineer===engName&&wds.includes(t.date)));
  c.querySelectorAll('input[data-type="travel"]').forEach(i=>{const v=parseFloat(i.value);if(v>0)travelDays.push({engineer:engName,date:i.dataset.date,hours:v})});
  persist(KEYS.travelDays,travelDays);
  // Save weekly notes
  weeklyNotes=weeklyNotes.filter(n=>!n.key.startsWith(engName+'|||')||!n.key.endsWith('|||'+wds[0]));
  c.querySelectorAll('input[data-type="note"]').forEach(i=>{const v=i.value.trim();if(v)weeklyNotes.push({key:i.dataset.notekey,note:v})});
  persist(KEYS.weeklyNotes,weeklyNotes);
  timesheetDirty=false;$('unsavedBadge').style.display='none';
  // Save timestamp
  const saveKey=`lastSaved_${engName}_${wds[0]}`;
  localStorage.setItem(saveKey,new Date().toISOString());
  renderTimesheet();renderLog();toast('Week saved');
  const we=entries.filter(e=>e.engineer===engName&&wds.includes(e.date));
  const wp=ptoUsage.filter(p=>p.engineer===engName&&wds.includes(p.date));
  const wt=travelDays.filter(t=>t.engineer===engName&&wds.includes(t.date));
  const wn=weeklyNotes.filter(n=>n.key.startsWith(engName+'|||')&&n.key.endsWith('|||'+wds[0]));
  syncToSharePoint(engName,we,wp,wt,wn,wds[0]);
}

// Sync
function setSyncStatus(s,m){const el=$('syncStatus');if(s==='none'){el.innerHTML='';return}el.innerHTML=`<span class="sync-dot ${s}"></span> ${m}`}
async function syncToSharePoint(engName,we,wp,wt,wn,weekOf){
  const url=localStorage.getItem(KEYS.flowUrl);if(!url){setSyncStatus('error','No Flow URL — saved locally');return}
  setSyncStatus('pending','Syncing...');const rows=[];
  const rate=getCostRate();
  we.forEach(e=>{const note=(wn||[]).find(n=>{const p=n.key.split('|||');return p[1]===e.project&&p[2]===e.job});rows.push({Date:e.date,Engineer:e.engineer,Project:e.project,Job:e.job,Category:e.category,Hours:e.hours,Cost:+(e.hours*rate).toFixed(2),Note:note?note.note:'',Type:'Project',WeekOf:weekOf,SubmittedAt:new Date().toISOString()})});
  wp.forEach(p=>rows.push({Date:p.date,Engineer:engName,Project:'PTO',Job:'PTO',Category:'PTO',Hours:p.hours,Type:'PTO',WeekOf:weekOf,SubmittedAt:new Date().toISOString()}));
  wt.forEach(t=>rows.push({Date:t.date,Engineer:engName,Project:'Travel',Job:'Travel',Category:'Travel',Hours:t.hours,Type:'Travel',WeekOf:weekOf,SubmittedAt:new Date().toISOString()}));
  if(!rows.length){setSyncStatus('none','');return}
  try{const r=await fetch(url,{method:'POST',headers:{'Content-Type':'application/json'},body:JSON.stringify({engineer:engName,weekOf,entries:rows})});if(!r.ok)throw new Error(`HTTP ${r.status}`);setSyncStatus('success','Synced to SharePoint')}catch(err){setSyncStatus('error','Sync failed — '+err.message)}
}

// Dropdowns
function populateDropdowns(){
  [$('timesheetEngineer'),$('filterEngineer')].forEach(sel=>{const v=sel.value,ph=sel.options[0].text;sel.innerHTML=`<option value="">${ph}</option>`;engineers.forEach(e=>sel.innerHTML+=`<option value="${e.name}">${e.name}</option>`);sel.value=v});
  const fp=$('filterProject'),fpv=fp.value;fp.innerHTML='<option value="">All Projects</option>';projects.forEach(p=>fp.innerHTML+=`<option value="${p.name}">${p.name}</option>`);fp.value=fpv;
  const fc=$('filterCategory'),fcv=fc.value;fc.innerHTML='<option value="">All Categories</option>';categories.forEach(c=>fc.innerHTML+=`<option value="${c}">${c}</option>`);fc.value=fcv;
}

// Log
function getFilteredEntries(){const eng=$('filterEngineer').value,proj=$('filterProject').value,cat=$('filterCategory').value,from=$('filterFrom').value,to=$('filterTo').value;return entries.filter(e=>(!eng||e.engineer===eng)&&(!proj||e.project===proj)&&(!cat||e.category===cat)&&(!from||e.date>=from)&&(!to||e.date<=to))}
function renderLog(){
  const f=getFilteredEntries(),body=$('logBody');
  if(!f.length){body.innerHTML='<tr><td colspan="6" class="empty-state">No entries.</td></tr>'}
  else{const sorted=[...f].sort((a,b)=>b.date.localeCompare(a.date)||a.engineer.localeCompare(b.engineer));body.innerHTML=sorted.map(e=>{const ri=entries.indexOf(e);return`<tr><td>${formatDate(e.date)}</td><td>${esc(e.engineer)}</td><td>${esc(e.project)} / ${esc(e.job||'')}</td><td>${esc(e.category||'')}</td><td>${e.hours}</td><td><button class="btn btn-danger btn-sm" onclick="deleteEntry(${ri})">Remove</button></td></tr>`}).join('')}
  const total=f.reduce((s,e)=>s+e.hours,0);
  $('summary').innerHTML=`<div class="stat"><div class="label">Total Hours</div><div class="value">${total.toFixed(1)}</div></div>
    <div class="stat"><div class="label">Entries</div><div class="value">${f.length}</div></div>
    <div class="stat"><div class="label">Engineers</div><div class="value">${new Set(f.map(e=>e.engineer)).size}</div></div>
    <div class="stat"><div class="label">Projects</div><div class="value">${new Set(f.map(e=>e.project)).size}</div></div>`
}
function deleteEntry(i){entries.splice(i,1);persist(KEYS.entries,entries);renderLog();renderTimesheet();toast('Removed')}
function clearFilters(){$('filterEngineer').value='';$('filterProject').value='';$('filterCategory').value='';$('filterFrom').value='';$('filterTo').value='';renderLog()}
function exportCSV(){const f=getFilteredEntries();if(!f.length){toast('No entries');return}const rate=getCostRate();const rows=[['Date','Engineer','Project','Job','Category','Hours','Cost']];f.sort((a,b)=>a.date.localeCompare(b.date)).forEach(e=>{rows.push([e.date,e.engineer,e.project,e.job||'',e.category||'',e.hours,+(e.hours*rate).toFixed(2)])});const csv=rows.map(r=>r.map(c=>`"${c}"`).join(',')).join('\n');const blob=new Blob([csv],{type:'text/csv'});const u=URL.createObjectURL(blob);const a=document.createElement('a');a.href=u;a.download=`time-entries-${new Date().toISOString().slice(0,10)}.csv`;a.click();URL.revokeObjectURL(u);toast('CSV exported')}

// Events
['filterEngineer','filterProject','filterCategory','filterFrom','filterTo'].forEach(id=>$(id).addEventListener('change',renderLog));
$('newProjectName').addEventListener('keydown',e=>{if(e.key==='Enter'){e.preventDefault();addProject()}});
$('newJobName').addEventListener('keydown',e=>{if(e.key==='Enter'){e.preventDefault();addJob()}});
$('newCategory').addEventListener('keydown',e=>{if(e.key==='Enter'){e.preventDefault();addCategory()}});
$('engName').addEventListener('keydown',e=>{if(e.key==='Enter'){e.preventDefault();addEngineer()}});

// ===== USER DETECTION =====
let currentUser=null;
const REMEMBERED_USER_KEY='rememberedEngineer';

function setActiveUser(name){
  currentUser=name;
  localStorage.setItem(REMEMBERED_USER_KEY,name);
  $('timesheetEngineer').value=name;
  $('timesheetEngineer').style.display='none';
  $('userBadge').textContent=name;
  $('userBadge').style.display='inline-block';
  $('switchUserBtn').style.display='inline-block';
  timesheetRows=[];timesheetDirty=false;renderTimesheet();
}

function switchUser(){
  currentUser=null;
  localStorage.removeItem(REMEMBERED_USER_KEY);
  $('timesheetEngineer').style.display='';
  $('timesheetEngineer').value='';
  $('userBadge').style.display='none';
  $('switchUserBtn').style.display='none';
  timesheetRows=[];timesheetDirty=false;renderTimesheet();
}

function matchEngineer(displayName,email){
  // Try exact display name match first
  let match=engineers.find(e=>e.name.toLowerCase()===displayName.toLowerCase());
  if(match) return match.name;
  // Try partial match (first+last in either order)
  const parts=displayName.toLowerCase().split(/[\s,]+/).filter(Boolean);
  match=engineers.find(e=>{const ep=e.name.toLowerCase();return parts.every(p=>ep.includes(p))});
  if(match) return match.name;
  // Try email prefix match
  if(email){const prefix=email.split('@')[0].replace(/[._-]/g,' ').toLowerCase();match=engineers.find(e=>e.name.toLowerCase().includes(prefix)||prefix.includes(e.name.toLowerCase().split(' ')[0]));if(match)return match.name}
  return null;
}

async function detectUser(){
  // 1. Check for remembered user
  const remembered=localStorage.getItem(REMEMBERED_USER_KEY);
  if(remembered&&engineers.find(e=>e.name===remembered)){setActiveUser(remembered);return}

  // 2. SharePoint context (_spPageContextInfo)
  if(typeof _spPageContextInfo!=='undefined'&&_spPageContextInfo.userDisplayName){
    const name=matchEngineer(_spPageContextInfo.userDisplayName,_spPageContextInfo.userEmail||'');
    if(name){setActiveUser(name);return}
  }

  // 3. SharePoint REST API (works on modern SharePoint pages)
  try{
    const resp=await fetch('/_api/web/currentuser',{headers:{'Accept':'application/json;odata=verbose'},credentials:'include'});
    if(resp.ok){const data=await resp.json();const u=data.d;const name=matchEngineer(u.Title||'',u.Email||'');if(name){setActiveUser(name);return}}
  }catch{}

  // 4. Microsoft Graph (if running in context with auth)
  try{
    const resp=await fetch('https://graph.microsoft.com/v1.0/me',{headers:{'Accept':'application/json'},credentials:'include'});
    if(resp.ok){const u=await resp.json();const name=matchEngineer(u.displayName||'',u.mail||u.userPrincipalName||'');if(name){setActiveUser(name);return}}
  }catch{}

  // 5. Fallback: show dropdown, but auto-select on change and remember
}

// When engineer is manually selected, remember them
$('timesheetEngineer').addEventListener('change',()=>{
  if(timesheetDirty&&!confirm('Unsaved changes. Discard?'))return;
  const val=$('timesheetEngineer').value;
  if(val){setActiveUser(val)}else{switchUser()}
});

// Init
$('flowUrl').value=localStorage.getItem(KEYS.flowUrl)||'';
$('costRate').value=getCostRate();
$('hoursPerDay').value=getHoursPerDay();
$('engStartDate').value=dateStr(new Date());
if(!load(KEYS.categories,null))persist(KEYS.categories,categories);
populateDropdowns();detectUser();
</script>
</body>
</html>
