-- =============================================
-- HOSTEL REGISTER — Full Database Setup
-- Run this in Supabase SQL Editor (Dashboard → SQL Editor → New Query)
-- =============================================

-- 1. STUDENTS
CREATE TABLE IF NOT EXISTS students (
  id           UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  wing         TEXT NOT NULL CHECK (wing IN ('Senior','Junior')),
  name         TEXT NOT NULL,
  class        TEXT,
  roll_no      TEXT,
  guardian_name  TEXT,
  guardian_phone TEXT,
  address      TEXT,
  blood_group  TEXT,
  medical_condition TEXT,
  room         TEXT,
  bed_no       TEXT,
  almirah_no   TEXT,
  admission_date DATE,
  created_at   TIMESTAMPTZ DEFAULT now()
);

-- 2. ATTENDANCE
CREATE TABLE IF NOT EXISTS attendance (
  id           UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  date         DATE NOT NULL,
  session      TEXT NOT NULL,
  wing         TEXT NOT NULL,
  student_id   UUID REFERENCES students(id) ON DELETE CASCADE,
  student_name TEXT,
  room         TEXT,
  status       TEXT NOT NULL CHECK (status IN ('Present','Absent','Leave')),
  created_at   TIMESTAMPTZ DEFAULT now(),
  UNIQUE (date, session, student_id)
);

-- 3. FINES
CREATE TABLE IF NOT EXISTS fines (
  id           UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  student_id   UUID REFERENCES students(id) ON DELETE CASCADE,
  student_name TEXT,
  wing         TEXT,
  amount       NUMERIC DEFAULT 0,
  reason       TEXT,
  paid         BOOLEAN DEFAULT false,
  collected_by TEXT,
  date         DATE,
  created_at   TIMESTAMPTZ DEFAULT now()
);

-- 4. MEDICAL
CREATE TABLE IF NOT EXISTS medical (
  id           UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  student_id   UUID REFERENCES students(id) ON DELETE CASCADE,
  student_name TEXT,
  wing         TEXT,
  condition    TEXT,
  treatment    TEXT,
  severity     TEXT CHECK (severity IN ('Low','Medium','High')),
  date         DATE,
  created_at   TIMESTAMPTZ DEFAULT now()
);

-- 5. LEAVES
CREATE TABLE IF NOT EXISTS leaves (
  id           UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  student_id   UUID REFERENCES students(id) ON DELETE CASCADE,
  student_name TEXT,
  wing         TEXT,
  from_date    DATE,
  to_date      DATE,
  reason       TEXT,
  destination  TEXT,
  approved_by  TEXT,
  created_at   TIMESTAMPTZ DEFAULT now()
);

-- 6. DEFAULTERS
CREATE TABLE IF NOT EXISTS defaulters (
  id           UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  student_id   UUID REFERENCES students(id) ON DELETE CASCADE,
  student_name TEXT,
  wing         TEXT,
  violation    TEXT,
  action       TEXT,
  resolved     BOOLEAN DEFAULT false,
  date         DATE,
  created_at   TIMESTAMPTZ DEFAULT now()
);


-- =============================================
-- ENABLE ROW LEVEL SECURITY ON ALL TABLES
-- =============================================

ALTER TABLE students   ENABLE ROW LEVEL SECURITY;
ALTER TABLE attendance ENABLE ROW LEVEL SECURITY;
ALTER TABLE fines      ENABLE ROW LEVEL SECURITY;
ALTER TABLE medical    ENABLE ROW LEVEL SECURITY;
ALTER TABLE leaves     ENABLE ROW LEVEL SECURITY;
ALTER TABLE defaulters ENABLE ROW LEVEL SECURITY;


-- =============================================
-- RLS POLICIES — only authenticated users can access
-- =============================================

-- STUDENTS
CREATE POLICY "Authenticated users can read students"
  ON students FOR SELECT TO authenticated USING (true);

CREATE POLICY "Authenticated users can insert students"
  ON students FOR INSERT TO authenticated WITH CHECK (true);

CREATE POLICY "Authenticated users can update students"
  ON students FOR UPDATE TO authenticated USING (true) WITH CHECK (true);

CREATE POLICY "Authenticated users can delete students"
  ON students FOR DELETE TO authenticated USING (true);

-- ATTENDANCE
CREATE POLICY "Authenticated users can read attendance"
  ON attendance FOR SELECT TO authenticated USING (true);

CREATE POLICY "Authenticated users can insert attendance"
  ON attendance FOR INSERT TO authenticated WITH CHECK (true);

CREATE POLICY "Authenticated users can update attendance"
  ON attendance FOR UPDATE TO authenticated USING (true) WITH CHECK (true);

CREATE POLICY "Authenticated users can delete attendance"
  ON attendance FOR DELETE TO authenticated USING (true);

-- FINES
CREATE POLICY "Authenticated users can read fines"
  ON fines FOR SELECT TO authenticated USING (true);

CREATE POLICY "Authenticated users can insert fines"
  ON fines FOR INSERT TO authenticated WITH CHECK (true);

CREATE POLICY "Authenticated users can update fines"
  ON fines FOR UPDATE TO authenticated USING (true) WITH CHECK (true);

CREATE POLICY "Authenticated users can delete fines"
  ON fines FOR DELETE TO authenticated USING (true);

-- MEDICAL
CREATE POLICY "Authenticated users can read medical"
  ON medical FOR SELECT TO authenticated USING (true);

CREATE POLICY "Authenticated users can insert medical"
  ON medical FOR INSERT TO authenticated WITH CHECK (true);

CREATE POLICY "Authenticated users can update medical"
  ON medical FOR UPDATE TO authenticated USING (true) WITH CHECK (true);

CREATE POLICY "Authenticated users can delete medical"
  ON medical FOR DELETE TO authenticated USING (true);

-- LEAVES
CREATE POLICY "Authenticated users can read leaves"
  ON leaves FOR SELECT TO authenticated USING (true);

CREATE POLICY "Authenticated users can insert leaves"
  ON leaves FOR INSERT TO authenticated WITH CHECK (true);

CREATE POLICY "Authenticated users can update leaves"
  ON leaves FOR UPDATE TO authenticated USING (true) WITH CHECK (true);

CREATE POLICY "Authenticated users can delete leaves"
  ON leaves FOR DELETE TO authenticated USING (true);

-- DEFAULTERS
CREATE POLICY "Authenticated users can read defaulters"
  ON defaulters FOR SELECT TO authenticated USING (true);

CREATE POLICY "Authenticated users can insert defaulters"
  ON defaulters FOR INSERT TO authenticated WITH CHECK (true);

CREATE POLICY "Authenticated users can update defaulters"
  ON defaulters FOR UPDATE TO authenticated USING (true) WITH CHECK (true);

CREATE POLICY "Authenticated users can delete defaulters"
  ON defaulters FOR DELETE TO authenticated USING (true);
