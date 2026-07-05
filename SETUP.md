# Baluni Hostel Management (v3) — Setup Guide

Role-based hostel management for **Baluni School of Competition, Farah, Mathura**.
Works on any phone, tablet, laptop or desktop from one link. Professional light UI.

**Two logins:**

| Role | Login | Can do |
|---|---|---|
| **Principal** | Principal + password | Everything — student records, edits, deletes, password change |
| **Warden** | Warden + password | Entry work only — attendance, leave, outpass, medical, discipline, fines, complaints, parent calls |

Wardens **cannot** open student files (address, parent phones, medical details are blocked at the
database level, not just hidden), cannot edit or delete records, and have no password controls.

---

## Step 1 — Database (Supabase)

Your Supabase project already exists (`bycpckezurktamehbgje`). Two scripts to run:

1. Supabase Dashboard → **SQL Editor** → New query → paste ALL of **schema_v3.sql** → **Run**.
   This upgrades your database: adds outpass, discipline, complaints, parent-call tables,
   parent phone columns, and the role security rules. It never deletes existing data.
2. Paste ALL of **create_logins.sql** → **Run**. This creates both logins
   (and if they already exist, it just resets their passwords):

   | Role | Email | Password |
   |---|---|---|
   | Warden | `staff@hostel.app` | `staff@123` |
   | Principal | `principal@hostel.app` | `principalbaluni@321` |

   Safe to re-run any time you forget a password. Change the Principal password from the app
   (Settings) once things are running. (`setup_v2.sql` is old — ignore it; this replaces it.)

## Step 2 — The app file

**index.html** already contains your project URL and key — nothing to paste.
(If you ever move to a new Supabase project, update the CONFIG block at the top of the script.)

## Step 3 — Host it

- **Netlify Drop** (easiest): https://app.netlify.com/drop → drag **index.html** → get your link.
- **GitHub + Netlify**: push the repo, import in Netlify → auto-deploys on every change.

## Step 4 — Daily use

- **Attendance** — 3 sessions (Morning / Evening / Night), per wing. Statuses: Present, Absent,
  Leave, Outpass, Sick. Students on leave or an open outpass are pre-marked automatically.
  Save → WhatsApp message ready for that wing's group.
- **Daily report** — Dashboard → pick date → Generate → send to the Principal's WhatsApp.
  (A web page can't auto-send at 10 PM by itself; this is one tap instead.)
- **Rooms** — tap G1–G14 / F1–F14 buttons, or type any custom room. Warns on double-booked
  bed/almirah in the same wing + room.
- **Leave** — from/to dates, parent consent, reason. Feeds attendance + daily report automatically.
- **Outpass** — numbered passes, time out/expected return, guardian details, "Mark returned".
- **Discipline & defaulters** — categories (uniform, cleanliness, late, mobile…), penalty points,
  action taken, open/resolved.
- **Fines** — typed amount each time, paid/unpaid, unpaid total shown.
- **Complaints** — student or parent, category, ticket number, Pending → In Progress → Resolved.
- **Parent calls** — log date + start/end (minutes auto-calculated, flags under 10 min);
  "Calls due this week" lists every student with no call in the last 7 days.

## Passwords

- **Principal password**: change inside the app (Settings) or in Supabase.
- **Warden password**: change in Supabase → Authentication → Users → `staff@hostel.app` →
  ⋮ → Reset/Update password. Wardens cannot change any password from the app.

## Honest notes

- Warden restrictions are enforced by database security rules (Row Level Security) — even a
  technical person with the warden password cannot pull addresses/phone numbers or edit history.
- WhatsApp cannot be auto-sent or auto-targeted to a group from a web page; the app pre-writes
  the message, you pick the group and tap Send.
- Not included (would need a paid backend / native app): parent & student self-service logins,
  automatic SMS alerts, scheduled 10 PM auto-reports, QR-code passes, photo/document storage,
  mess/inventory/visitor/fees modules. All are possible later — this covers the daily-operations core.
- Backups: Supabase → Table Editor → export any table to CSV.
