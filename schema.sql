-- ============================================================
--  HOSTEL REGISTER — Supabase database schema
--  Run this ONCE in Supabase Dashboard → SQL Editor → New query → Run
-- ============================================================

-- ---------- TABLES ----------

create table if not exists students (
  id              uuid primary key default gen_random_uuid(),
  created_at      timestamptz default now(),
  wing            text not null,            -- 'Senior' | 'Junior'
  name            text not null,
  class           text,
  roll_no         text,
  guardian_name   text,
  guardian_phone  text,
  address         text,
  blood_group     text,
  medical_condition text,
  room            text,                     -- G1, G2, F1, F2 ...
  bed_no          text,
  almirah_no      text,
  admission_date  date
);

create table if not exists attendance (
  id          uuid primary key default gen_random_uuid(),
  created_at  timestamptz default now(),
  date        date not null,
  session     text not null,                -- 'Morning' | 'Night'
  wing        text,
  student_id  uuid references students(id) on delete cascade,
  student_name text,
  room        text,
  status      text not null,                -- 'Present' | 'Absent' | 'Leave'
  marked_by   text,
  unique (date, session, student_id)
);

create table if not exists fines (
  id           uuid primary key default gen_random_uuid(),
  created_at   timestamptz default now(),
  date         date default current_date,
  student_id   uuid references students(id) on delete set null,
  student_name text,
  wing         text,
  reason       text,
  amount       numeric,
  paid         boolean default false,
  collected_by text
);

create table if not exists medical (
  id           uuid primary key default gen_random_uuid(),
  created_at   timestamptz default now(),
  date         date default current_date,
  student_id   uuid references students(id) on delete set null,
  student_name text,
  wing         text,
  condition    text,
  treatment    text,
  severity     text                         -- 'Low' | 'Medium' | 'High'
);

create table if not exists leaves (
  id           uuid primary key default gen_random_uuid(),
  created_at   timestamptz default now(),
  student_id   uuid references students(id) on delete set null,
  student_name text,
  wing         text,
  from_date    date,
  to_date      date,
  reason       text,
  destination  text,
  approved_by  text
);

create table if not exists defaulters (
  id           uuid primary key default gen_random_uuid(),
  created_at   timestamptz default now(),
  date         date default current_date,
  student_id   uuid references students(id) on delete set null,
  student_name text,
  wing         text,
  violation    text,
  action       text,
  resolved     boolean default false
);

-- ---------- ROW LEVEL SECURITY ----------
-- Only a logged-in (authenticated) user — i.e. someone who signed in with the
-- shared staff password — can read or write. The public anon key alone CANNOT
-- touch the data. This is the real lock; the password screen is not just a curtain.

alter table students   enable row level security;
alter table attendance enable row level security;
alter table fines      enable row level security;
alter table medical    enable row level security;
alter table leaves     enable row level security;
alter table defaulters enable row level security;

create policy "staff full access" on students   for all to authenticated using (true) with check (true);
create policy "staff full access" on attendance for all to authenticated using (true) with check (true);
create policy "staff full access" on fines      for all to authenticated using (true) with check (true);
create policy "staff full access" on medical    for all to authenticated using (true) with check (true);
create policy "staff full access" on leaves     for all to authenticated using (true) with check (true);
create policy "staff full access" on defaulters for all to authenticated using (true) with check (true);

-- ---------- HELPFUL INDEXES ----------
create index if not exists idx_students_wing on students (wing);
create index if not exists idx_att_date on attendance (date, session, wing);
create index if not exists idx_fines_paid on fines (paid);
create index if not exists idx_def_resolved on defaulters (resolved);
