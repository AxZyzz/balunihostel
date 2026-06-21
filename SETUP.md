# Hostel Register — Setup Guide

A shared hostel app: one live database, opens on any phone or computer, protected by one
staff password. Built for two wings (Senior + Junior), with attendance, fines, medical, leave
and defaulter records, plus a WhatsApp message builder.

You set it up **once**. After that, staff just open a link and type the password.

---

## What you need (all free)
1. A **Supabase** account (free) — this is the cloud database.
2. A **Netlify** or **GitHub Pages** account (free) — this hosts the page so it has a real link.

Total time: ~15 minutes, one time.

---

## Step 1 — Create the database (Supabase)

1. Go to **https://supabase.com** → **Start your project** → sign in with Google.
2. Click **New project**. Give it a name (e.g. `hostel`), set a database password (save it
   somewhere — you won't need it daily), pick the nearest region, click **Create**.
3. Wait ~1 minute for it to finish setting up.

### 1a. Create the tables
1. In the left menu click **SQL Editor** → **New query**.
2. Open the file **schema.sql** (sent with this app), copy **all** of it, paste into the box.
3. Click **Run**. You should see *Success*. (This creates all the tables and the security rules.)

### 1b. Create the one shared staff login
1. Left menu → **Authentication** → **Users** → **Add user** → **Create new user**.
2. Email: type exactly **staff@hostel.app**
   (this exact email is what the app logs in with — don't change it unless you also change it
   in the app file, see Step 3).
3. Password: choose the **staff password** you'll give your team (at least 6 characters).
4. Tick **Auto Confirm User** if shown, then **Create user**.

> This is the password your staff type to open the app. You can change it later from inside
> the app (Settings → Change password) or here in Supabase.

### 1c. Copy your two connection values
1. Left menu → **Project Settings** (gear icon) → **API**.
2. Copy two things:
   - **Project URL** (looks like `https://abcdxyz.supabase.co`)
   - **anon public** key (a long string under *Project API keys*)

Keep these two for Step 3.

---

## Step 2 — (already done) the app file
You have **index.html**. That's the whole app — one file.

---

## Step 3 — Put your two values into the app
1. Open **index.html** in any text editor (Notepad works).
2. Near the top of the `<script>` section you'll see this **CONFIG** block:

   ```js
   const SUPABASE_URL      = "PASTE_YOUR_SUPABASE_URL_HERE";
   const SUPABASE_ANON_KEY = "PASTE_YOUR_ANON_KEY_HERE";
   const HOSTEL_EMAIL      = "staff@hostel.app";
   ```

3. Replace `PASTE_YOUR_SUPABASE_URL_HERE` with your **Project URL** (keep the quotes).
4. Replace `PASTE_YOUR_ANON_KEY_HERE` with your **anon public** key (keep the quotes).
5. Leave `HOSTEL_EMAIL` as `staff@hostel.app` (must match the user you made in Step 1b).
6. Save the file.

---

## Step 4 — Host it (pick ONE)

### Option A — Netlify Drop (easiest, no GitHub)
1. Go to **https://app.netlify.com/drop**.
2. Drag your **index.html** onto the page (or a folder containing it).
3. It instantly gives you a link like `https://something.netlify.app`. That's your app.
4. (Optional) In Netlify → Site settings you can rename it to something tidier.

### Option B — GitHub + Netlify
1. Create a new GitHub repository, upload **index.html** (and schema.sql / SETUP.md if you like).
2. In Netlify → **Add new site → Import from GitHub** → pick the repo → **Deploy**.
3. Netlify watches GitHub, so future edits you push update the live site automatically.

---

## Step 5 — Use it
1. Open the link. Type the **staff password** (from Step 1b). You're in.
2. **Students** tab → add students (pick wing, room, bed, almirah — it warns on clashes).
3. **Attendance** tab → pick date + session + wing → **Load list** → tap P/A/L → **Save** →
   then **Copy message** / **Open WhatsApp**, and paste into that wing's group.
4. **Fines / Medical / Leave / Defaulters** tabs → add records, all linked to students.
5. **Dashboard** → today's numbers at a glance. Top-right toggle switches Senior / Junior / Both.
6. Share the link + password with your staff. Same live data for everyone.

### Changing the password later
Settings tab → **Change password** → everyone logs in again with the new one.
(Or change it in Supabase → Authentication → Users.)

---

## Honest notes
- **Security:** The data is locked behind the staff login (Supabase Row Level Security). Anyone
  *without* the password cannot read or change anything, even if they find the link. The one
  caveat of a shared password is the obvious one — anyone you give it to has full access, so only
  share it with trusted staff, and change it when someone leaves.
- **WhatsApp:** Phones don't allow auto-sending or auto-picking a group from a web page. The app
  gets the message fully written for you; you tap the correct wing group and press Send. One tap.
- **Free limits:** Supabase's free tier is far more than a hostel needs. It pauses a project only
  after a long stretch of zero activity; daily use keeps it awake.
- **Backups:** Your data lives in Supabase. You can export any table to CSV from the Supabase
  Table Editor anytime if you want an offline copy.
