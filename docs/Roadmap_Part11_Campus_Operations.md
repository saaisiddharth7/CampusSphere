# CampusSphere – Complete Roadmap

## Part 11: Campus Operations Modules – Hostel Management & Inventory Management

> **Document Series:** Part 11 of 13
> **Continues from:** [Part 10: Campus Life & Governance](./Roadmap_Part10_CampusLife_Governance.md)

---

## 11.1 Hostel Management Module

### Overview

End-to-end hostel operations management covering room allocation, mess management, visitor logs, complaints, laundry booking, and warden dashboards. Designed for the Indian hostel system with separate boys/girls hostels, wardens, and mess contractors.

### Feature Breakdown

```
┌──────────────────────────────────────────────────────────────────────┐
│              HOSTEL MANAGEMENT – FEATURES                             │
│                                                                      │
│  🏠 Room Allocation                                                  │
│  ├── Room inventory (block, floor, room, capacity, type)            │
│  ├── Assignment: Admin assigns rooms during admission               │
│  ├── Room swap requests (student → warden approval)                 │
│  ├── Vacancy tracking + waiting list                                │
│  ├── Roommate preferences (optional)                                │
│  └── Room condition report (check-in / check-out)                   │
│                                                                      │
│  🍽️ Mess Management                                                  │
│  ├── Weekly menu display (set by mess committee/warden)             │
│  ├── Daily menu updates + special meals                             │
│  ├── Meal attendance tracking (QR scan at mess entry)               │
│  ├── Feedback rating per meal (1-5 stars + comment)                 │
│  ├── Mess fee tracking (monthly, separate from academic fees)       │
│  └── Mess rebate requests (when student is on leave)                │
│                                                                      │
│  👥 Visitor Management                                               │
│  ├── Student raises visitor request (name, relation, date/time)     │
│  ├── Warden approves/rejects                                        │
│  ├── Security guard check-in/out with timestamp                     │
│  └── Auto-notification to student when visitor arrives              │
│                                                                      │
│  🔧 Complaints                                                       │
│  ├── Maintenance requests (plumbing, electrical, furniture)         │
│  ├── Category-based routing to maintenance staff                    │
│  ├── SLA tracking (similar to grievance system)                     │
│  └── Photo evidence upload                                          │
│                                                                      │
│  👕 Laundry Booking                                                  │
│  ├── Book laundry slot (day + time)                                 │
│  ├── Track laundry status (submitted → washing → ready → collected)│
│  └── Item count + condition notes                                   │
│                                                                      │
│  🔐 Gate Pass & Leave                                                │
│  ├── Leave application (dates, reason)                               │
│  ├── Warden approval (with parent SMS notification)                 │
│  ├── Gate pass generation (QR code)                                 │
│  └── Late night return tracking                                     │
└──────────────────────────────────────────────────────────────────────┘
```

### Database Schema

```sql
-- supabase/migrations/018_hostel_management.sql

-- Hostel Blocks
CREATE TABLE hostel_blocks (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id UUID NOT NULL REFERENCES tenants(id),
  name TEXT NOT NULL,                             -- "A Block (Boys)", "B Block (Girls)"
  block_type TEXT CHECK (block_type IN ('boys', 'girls', 'co_ed', 'pg', 'staff')),
  total_rooms INT NOT NULL,
  total_capacity INT NOT NULL,
  warden_id UUID REFERENCES faculty(id),
  address TEXT,
  contact_phone TEXT,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- Hostel Rooms
CREATE TABLE hostel_rooms (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id UUID NOT NULL REFERENCES tenants(id),
  block_id UUID NOT NULL REFERENCES hostel_blocks(id),
  room_number TEXT NOT NULL,
  floor INT NOT NULL,
  room_type TEXT DEFAULT 'shared' CHECK (room_type IN ('single', 'double', 'triple', 'dormitory')),
  capacity INT NOT NULL,
  current_occupancy INT DEFAULT 0,
  has_ac BOOLEAN DEFAULT false,
  has_attached_bathroom BOOLEAN DEFAULT false,
  monthly_rent DECIMAL(10,2),
  status TEXT DEFAULT 'available' CHECK (status IN ('available', 'full', 'maintenance', 'reserved')),
  UNIQUE(tenant_id, block_id, room_number)
);

-- Room Allocations (student → room)
CREATE TABLE hostel_allocations (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id UUID NOT NULL REFERENCES tenants(id),
  student_id UUID NOT NULL REFERENCES students(id),
  room_id UUID NOT NULL REFERENCES hostel_rooms(id),
  bed_number INT,
  academic_year TEXT NOT NULL,
  allocated_from DATE NOT NULL,
  allocated_until DATE,
  status TEXT DEFAULT 'active' CHECK (status IN ('active', 'vacated', 'transferred', 'suspended')),
  check_in_condition JSONB,                       -- Room condition at check-in
  check_out_condition JSONB,
  allocated_at TIMESTAMPTZ DEFAULT now()
);

-- Mess Menu
CREATE TABLE mess_menus (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id UUID NOT NULL REFERENCES tenants(id),
  block_id UUID REFERENCES hostel_blocks(id),     -- NULL = all hostels
  day_of_week INT NOT NULL CHECK (day_of_week BETWEEN 0 AND 6),
  meal_type TEXT NOT NULL CHECK (meal_type IN ('breakfast', 'lunch', 'snacks', 'dinner')),
  items TEXT[] NOT NULL,                          -- ["Idli", "Sambar", "Chutney", "Coffee"]
  is_special BOOLEAN DEFAULT false,
  special_occasion TEXT,
  valid_from DATE,
  valid_until DATE,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- Mess Feedback
CREATE TABLE mess_feedback (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id UUID NOT NULL REFERENCES tenants(id),
  student_id UUID NOT NULL REFERENCES students(id),
  meal_date DATE NOT NULL,
  meal_type TEXT NOT NULL,
  rating INT NOT NULL CHECK (rating BETWEEN 1 AND 5),
  comment TEXT,
  created_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(tenant_id, student_id, meal_date, meal_type)
);

-- Visitor Log
CREATE TABLE hostel_visitors (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id UUID NOT NULL REFERENCES tenants(id),
  student_id UUID NOT NULL REFERENCES students(id),
  visitor_name TEXT NOT NULL,
  visitor_phone TEXT NOT NULL,
  relationship TEXT NOT NULL,
  purpose TEXT,
  requested_date DATE NOT NULL,
  requested_time_slot TEXT,
  status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'rejected', 'checked_in', 'checked_out')),
  approved_by UUID REFERENCES users(id),
  check_in_time TIMESTAMPTZ,
  check_out_time TIMESTAMPTZ,
  security_notes TEXT,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- Hostel Leave / Gate Pass
CREATE TABLE hostel_leave_requests (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id UUID NOT NULL REFERENCES tenants(id),
  student_id UUID NOT NULL REFERENCES students(id),
  leave_type TEXT CHECK (leave_type IN ('day_out', 'overnight', 'weekend', 'vacation', 'emergency')),
  from_date DATE NOT NULL,
  to_date DATE NOT NULL,
  reason TEXT NOT NULL,
  destination TEXT,
  guardian_phone TEXT,
  status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'approved', 'rejected', 'active', 'returned')),
  approved_by UUID REFERENCES users(id),
  gate_pass_qr TEXT,                              -- QR code for security gate
  actual_out_time TIMESTAMPTZ,
  actual_in_time TIMESTAMPTZ,
  parent_notified BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- Hostel Maintenance Complaints
CREATE TABLE hostel_complaints (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id UUID NOT NULL REFERENCES tenants(id),
  student_id UUID NOT NULL REFERENCES students(id),
  room_id UUID NOT NULL REFERENCES hostel_rooms(id),
  complaint_type TEXT CHECK (complaint_type IN (
    'plumbing', 'electrical', 'furniture', 'cleaning', 'pest_control',
    'wifi', 'water', 'ac_fan', 'door_lock', 'other'
  )),
  description TEXT NOT NULL,
  photo_urls JSONB DEFAULT '[]',
  priority TEXT DEFAULT 'medium',
  status TEXT DEFAULT 'open' CHECK (status IN ('open', 'assigned', 'in_progress', 'resolved', 'closed')),
  assigned_to TEXT,                               -- Maintenance staff name
  resolved_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX idx_hostel_alloc ON hostel_allocations(tenant_id, student_id, status);
CREATE INDEX idx_hostel_visitors ON hostel_visitors(tenant_id, student_id, requested_date);
CREATE INDEX idx_hostel_leave ON hostel_leave_requests(tenant_id, student_id, status);
```

### API Endpoints

```
┌──────────────────────────────────────────────────────────────────────────┐
│  HOSTEL MANAGEMENT ENDPOINTS                                             │
├──────────────────────────────────────────────────────────────────────────┤
│  CRUD   /v1/hostel/blocks                  Hostel blocks                 │
│  CRUD   /v1/hostel/rooms                   Rooms (with filters)          │
│  POST   /v1/hostel/allocate                Allocate room to student      │
│  GET    /v1/hostel/my-room                 Student's room details        │
│  POST   /v1/hostel/swap-request            Room swap request             │
│  GET    /v1/hostel/vacancies               Available rooms               │
│  CRUD   /v1/hostel/mess/menus              Mess menu management          │
│  GET    /v1/hostel/mess/today              Today's menu                  │
│  POST   /v1/hostel/mess/feedback           Submit meal feedback          │
│  GET    /v1/hostel/mess/feedback/stats     Feedback statistics           │
│  POST   /v1/hostel/visitors               Request visitor visit          │
│  PUT    /v1/hostel/visitors/:id/approve    Approve visitor               │
│  POST   /v1/hostel/visitors/:id/checkin    Security check-in             │
│  POST   /v1/hostel/visitors/:id/checkout   Security check-out            │
│  POST   /v1/hostel/leave                   Apply for leave/gate pass     │
│  PUT    /v1/hostel/leave/:id/approve       Approve leave                 │
│  POST   /v1/hostel/leave/:id/gate-scan     Scan gate pass QR            │
│  POST   /v1/hostel/complaints              Submit complaint              │
│  GET    /v1/hostel/complaints              List complaints               │
│  PUT    /v1/hostel/complaints/:id          Update complaint status       │
│  GET    /v1/hostel/warden/dashboard        Warden dashboard              │
└──────────────────────────────────────────────────────────────────────────┘
```

### Wireframe: Hostel Dashboard (Student Mobile)

```
┌───────────────────────────────────────┐
│  ← Hostel                  🔔        │
├───────────────────────────────────────┤
│                                       │
│  🏠 My Room                           │
│  ┌─────────────────────────────────┐  │
│  │  A Block – Room 204             │  │
│  │  Floor: 2 | Type: Double        │  │
│  │  Bed: B | Roommate: Arun K      │  │
│  │  Warden: Prof. Suresh V         │  │
│  │  Warden Phone: 98765 12345      │  │
│  └─────────────────────────────────┘  │
│                                       │
│  ┌────────┐┌────────┐┌────────┐      │
│  │  🍽️    ││  👥    ││  🔐    │      │
│  │ Mess   ││ Visitor││ Leave  │      │
│  │ Menu   ││ Req    ││ Apply  │      │
│  └────────┘└────────┘└────────┘      │
│  ┌────────┐┌────────┐┌────────┐      │
│  │  🔧    ││  👕    ││  📊    │      │
│  │Complain││Laundry ││ Mess   │      │
│  │        ││ Book   ││ Rate   │      │
│  └────────┘└────────┘└────────┘      │
│                                       │
│  🍽️ Today's Mess Menu                 │
│  ┌─────────────────────────────────┐  │
│  │ 🌅 Breakfast (7-9 AM)          │  │
│  │ Idli, Sambar, Chutney, Coffee   │  │
│  ├─────────────────────────────────┤  │
│  │ 🌞 Lunch (12:30-2 PM)          │  │
│  │ Rice, Sambar, Rasam, Curd,      │  │
│  │ Potato Fry, Papad               │  │
│  ├─────────────────────────────────┤  │
│  │ 🫖 Snacks (4:30-5:30 PM)       │  │
│  │ Tea, Biscuits, Banana           │  │
│  ├─────────────────────────────────┤  │
│  │ 🌙 Dinner (7:30-9 PM)          │  │
│  │ Chapati, Dal, Mixed Veg Curry,  │  │
│  │ Rice, Buttermilk                │  │
│  └─────────────────────────────────┘  │
│                                       │
│  Pending: Leave req. approved ✅      │
│  Gate pass valid: Feb 22, 5PM-10PM   │
│                                       │
└───────────────────────────────────────┘
```

### Wireframe: Gate Pass / Leave (Student Mobile)

```
┌───────────────────────────────────────┐
│  ← Apply for Leave                     │
├───────────────────────────────────────┤
│                                       │
│  Leave Type:                           │
│  ○ Day Out  ◉ Overnight  ○ Weekend   │
│  ○ Vacation  ○ Emergency              │
│                                       │
│  ┌─────────────────────────────────┐  │
│  │ From: [Feb 22, 5:00 PM    📅]  │  │
│  └─────────────────────────────────┘  │
│  ┌─────────────────────────────────┐  │
│  │ To:   [Feb 23, 8:00 PM    📅]  │  │
│  └─────────────────────────────────┘  │
│                                       │
│  ┌─────────────────────────────────┐  │
│  │ Reason:                         │  │
│  │ Going home for family function  │  │
│  └─────────────────────────────────┘  │
│  ┌─────────────────────────────────┐  │
│  │ Destination: Coimbatore         │  │
│  └─────────────────────────────────┘  │
│  ┌─────────────────────────────────┐  │
│  │ Guardian Phone: +91 98765 43210 │  │
│  └─────────────────────────────────┘  │
│                                       │
│  ☑ Notify my parent via SMS           │
│                                       │
│  ┌─────────────────────────────────┐  │
│  │      📤 SUBMIT LEAVE REQUEST    │  │
│  └─────────────────────────────────┘  │
│                                       │
│  ── Previous Requests ──              │
│  ┌─────────────────────────────────┐  │
│  │  Feb 15: Weekend leave          │  │
│  │  Status: ✅ Approved            │  │
│  │  [📱 Show Gate Pass QR]         │  │
│  └─────────────────────────────────┘  │
│                                       │
└───────────────────────────────────────┘
```

---

## 11.2 Inventory Management Module

### Overview

Track all institutional assets: lab equipment, computers, projectors, library resources, sports equipment, and furniture. Includes check-out/check-in, maintenance scheduling, AMC tracking, and procurement requests.

### Feature Breakdown

```
┌──────────────────────────────────────────────────────────────────────┐
│              INVENTORY MANAGEMENT – FEATURES                          │
│                                                                      │
│  Asset Tracking:                                                     │
│  ├── Asset registry with unique tag IDs (QR/barcode)                │
│  ├── Categories: Lab equipment, computers, projectors, furniture,   │
│  │   sports, library, vehicles, misc                                 │
│  ├── Location tracking (building, room, lab)                        │
│  ├── Assignment tracking (which dept/faculty/lab)                   │
│  ├── Purchase date, warranty, AMC expiry                            │
│  └── Depreciation calculation                                       │
│                                                                      │
│  Check-out / Check-in:                                               │
│  ├── Faculty/staff can request equipment                            │
│  ├── Lab assistants manage check-out/return                         │
│  ├── QR code scan for quick process                                 │
│  ├── Overdue alerts                                                  │
│  └── Condition report on return                                     │
│                                                                      │
│  Maintenance:                                                        │
│  ├── Maintenance requests from faculty/staff                        │
│  ├── Scheduled maintenance calendar                                 │
│  ├── Vendor/service provider directory                              │
│  ├── Maintenance history log                                        │
│  └── Total cost of ownership reports                                │
│                                                                      │
│  Procurement:                                                        │
│  ├── Purchase request workflow (dept → HOD → admin → finance)       │
│  ├── Quotation comparison (3 quotes required)                       │
│  ├── Purchase order generation                                      │
│  └── Delivery and asset onboarding                                  │
└──────────────────────────────────────────────────────────────────────┘
```

### Database Schema

```sql
-- supabase/migrations/019_inventory.sql

-- Asset Categories
CREATE TABLE asset_categories (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id UUID NOT NULL REFERENCES tenants(id),
  name TEXT NOT NULL,                             -- "Lab Equipment", "Computers"
  code TEXT NOT NULL,                             -- "LAB", "COMP"
  parent_id UUID REFERENCES asset_categories(id),
  UNIQUE(tenant_id, code)
);

-- Assets
CREATE TABLE assets (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id UUID NOT NULL REFERENCES tenants(id),
  category_id UUID NOT NULL REFERENCES asset_categories(id),
  asset_tag TEXT NOT NULL,                        -- "XYZ-COMP-2024-0145"
  name TEXT NOT NULL,
  description TEXT,
  make TEXT,                                      -- Brand/manufacturer
  model TEXT,
  serial_number TEXT,

  -- Location
  building TEXT,
  floor TEXT,
  room TEXT,
  department_id UUID REFERENCES departments(id),
  assigned_to UUID REFERENCES users(id),          -- Faculty/staff responsible

  -- Financial
  purchase_date DATE,
  purchase_cost DECIMAL(12,2),
  vendor TEXT,
  invoice_number TEXT,
  invoice_url TEXT,                               -- R2 URL

  -- Warranty & AMC
  warranty_expiry DATE,
  amc_provider TEXT,
  amc_start DATE,
  amc_end DATE,
  amc_cost DECIMAL(10,2),

  -- Status
  condition TEXT DEFAULT 'good' CHECK (condition IN ('new', 'good', 'fair', 'poor', 'damaged', 'disposed')),
  status TEXT DEFAULT 'available' CHECK (status IN ('available', 'in_use', 'checked_out', 'maintenance', 'disposed', 'lost')),
  is_active BOOLEAN DEFAULT true,

  -- QR
  qr_code_data TEXT,

  created_at TIMESTAMPTZ DEFAULT now(),
  updated_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(tenant_id, asset_tag)
);

-- Asset Check-out / Check-in
CREATE TABLE asset_checkouts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id UUID NOT NULL REFERENCES tenants(id),
  asset_id UUID NOT NULL REFERENCES assets(id),
  checked_out_by UUID NOT NULL REFERENCES users(id),
  checked_out_to UUID NOT NULL REFERENCES users(id),
  purpose TEXT,
  checkout_date TIMESTAMPTZ DEFAULT now(),
  expected_return_date DATE,
  actual_return_date DATE,
  condition_at_checkout TEXT,
  condition_at_return TEXT,
  status TEXT DEFAULT 'checked_out' CHECK (status IN ('checked_out', 'returned', 'overdue', 'lost')),
  notes TEXT,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- Maintenance Records
CREATE TABLE asset_maintenance (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id UUID NOT NULL REFERENCES tenants(id),
  asset_id UUID NOT NULL REFERENCES assets(id),
  maintenance_type TEXT CHECK (maintenance_type IN ('repair', 'service', 'replacement', 'inspection', 'calibration')),
  requested_by UUID REFERENCES users(id),
  description TEXT NOT NULL,
  vendor TEXT,
  cost DECIMAL(10,2),
  status TEXT DEFAULT 'requested' CHECK (status IN ('requested', 'approved', 'in_progress', 'completed', 'rejected')),
  scheduled_date DATE,
  completed_date DATE,
  notes TEXT,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- Purchase Requests
CREATE TABLE purchase_requests (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  tenant_id UUID NOT NULL REFERENCES tenants(id),
  requested_by UUID NOT NULL REFERENCES users(id),
  department_id UUID REFERENCES departments(id),
  request_number TEXT NOT NULL,
  item_name TEXT NOT NULL,
  description TEXT,
  quantity INT NOT NULL,
  estimated_cost DECIMAL(12,2),
  justification TEXT NOT NULL,

  -- Approval workflow
  hod_approval TEXT DEFAULT 'pending' CHECK (hod_approval IN ('pending', 'approved', 'rejected')),
  hod_approved_by UUID REFERENCES users(id),
  admin_approval TEXT DEFAULT 'pending',
  admin_approved_by UUID REFERENCES users(id),
  finance_approval TEXT DEFAULT 'pending',

  -- Quotes
  quotations JSONB DEFAULT '[]',                  -- [{vendor, amount, fileUrl}]
  selected_vendor TEXT,
  final_cost DECIMAL(12,2),

  status TEXT DEFAULT 'draft' CHECK (status IN (
    'draft', 'submitted', 'hod_review', 'admin_review', 'finance_review',
    'approved', 'ordered', 'delivered', 'completed', 'rejected'
  )),

  created_at TIMESTAMPTZ DEFAULT now()
);

CREATE INDEX idx_assets_tenant ON assets(tenant_id, category_id, status);
CREATE INDEX idx_assets_dept ON assets(tenant_id, department_id);
CREATE INDEX idx_checkouts ON asset_checkouts(tenant_id, asset_id, status);
```

### API Endpoints

```
┌──────────────────────────────────────────────────────────────────────────┐
│  INVENTORY MANAGEMENT ENDPOINTS                                          │
├──────────────────────────────────────────────────────────────────────────┤
│  CRUD   /v1/inventory/categories         Asset categories                │
│  POST   /v1/inventory/assets             Add new asset                   │
│  GET    /v1/inventory/assets             List assets (w/ filters)        │
│  GET    /v1/inventory/assets/:id         Asset details + history         │
│  PUT    /v1/inventory/assets/:id         Update asset                    │
│  POST   /v1/inventory/assets/:id/checkout  Check-out asset              │
│  POST   /v1/inventory/assets/:id/checkin   Check-in asset               │
│  GET    /v1/inventory/overdue            Overdue check-outs              │
│  POST   /v1/inventory/scan              QR scan (lookup asset)          │
│  POST   /v1/inventory/maintenance        Request maintenance            │
│  PUT    /v1/inventory/maintenance/:id     Update maintenance status     │
│  POST   /v1/inventory/purchase-request    Submit purchase request       │
│  PUT    /v1/inventory/purchase-request/:id/approve  Approve step        │
│  GET    /v1/inventory/reports/summary     Inventory summary report      │
│  GET    /v1/inventory/reports/depreciation Depreciation report          │
│  GET    /v1/inventory/reports/amc-expiring AMC/warranty expiring        │
└──────────────────────────────────────────────────────────────────────────┘
```

### Wireframe: Asset Dashboard (Admin Web)

```
┌─────────────────────────────────────────────────────────────────────────┐
│  📦 Inventory Management                                                │
│  ────────────────────────                                               │
│                                                                         │
│  ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐ ┌──────────┐    │
│  │ Total    │ │ In Use   │ │ Available│ │ Maint.   │ │ Value    │    │
│  │ 1,847    │ │ 1,204    │ │ 583      │ │ 60       │ │ ₹1.2Cr   │    │
│  └──────────┘ └──────────┘ └──────────┘ └──────────┘ └──────────┘    │
│                                                                         │
│  ┌────────────────────────────────────────────────────────────────────┐ │
│  │ 🔍 Search assets...  [Category ▼] [Dept ▼] [Status ▼] [+ Add]   │ │
│  └────────────────────────────────────────────────────────────────────┘ │
│                                                                         │
│  ┌────────────────────────────────────────────────────────────────────┐ │
│  │ Tag          Name              Category   Location  Status  Cond.│ │
│  ├────────────────────────────────────────────────────────────────────┤ │
│  │ COMP-0145    Dell Optiplex 5080 Computer   Lab-2    In Use   Good│ │
│  │ PROJ-0023    Epson EB-2155W     Projector  302      Avail.   Good│ │
│  │ LAB-0089     Oscilloscope TDS   Lab Equip  ECE-Lab  Maint.   Fair│ │
│  │ FURN-0312    Student Desk       Furniture  301      In Use   Good│ │
│  │ COMP-0146    HP ProBook 450     Computer   CL-1     Checked  Good│ │
│  │              G8                             Out              │ │
│  └────────────────────────────────────────────────────────────────────┘ │
│                                                                         │
│  ⚠️ Alerts:                                                             │
│  ├── 🔴 5 assets overdue for return                                    │
│  ├── 🟠 12 AMC expiring within 30 days                                 │
│  └── 🟡 3 pending purchase requests                                    │
│                                                                         │
│  [📊 Generate Report]  [📥 Export CSV]  [📷 Bulk QR Print]            │
└─────────────────────────────────────────────────────────────────────────┘
```

---

> **→ Continue to [Part 12: Career & Alumni Modules](./Roadmap_Part12_Career_Alumni.md)**
