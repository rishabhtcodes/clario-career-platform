-- ============================================================
--  CLARIO CAREER PLATFORM - Complete Supabase Database Schema
--  Run this in your Supabase SQL Editor at:
--  https://supabase.com/dashboard/project/veiucmeaejlvcofkoide/sql
-- ============================================================

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================================
-- 1. USERS TABLE
-- ============================================================
CREATE TABLE IF NOT EXISTS public.users (
  id                   BIGSERIAL PRIMARY KEY,
  created_at           TIMESTAMPTZ DEFAULT NOW(),
  "userName"           TEXT NOT NULL DEFAULT 'clarioUser',
  "userEmail"          TEXT UNIQUE NOT NULL,
  avatar               TEXT,
  "totalCredits"       INTEGER DEFAULT 10,
  "remainingCredits"   INTEGER DEFAULT 10,
  invite_link          TEXT UNIQUE,
  current_status       TEXT DEFAULT '',
  "userPhone"          TEXT DEFAULT '',
  "institutionName"    TEXT DEFAULT '',
  "mainFocus"          TEXT DEFAULT '',
  is_verified          BOOLEAN DEFAULT FALSE,
  "isQuizDone"         BOOLEAN DEFAULT FALSE,
  latitude             DOUBLE PRECISION,
  longitude            DOUBLE PRECISION,
  "isPro"              BOOLEAN DEFAULT FALSE,
  google_refresh_token TEXT DEFAULT '',
  "calendarConnected"  BOOLEAN DEFAULT FALSE
);

ALTER TABLE public.users ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users select all"  ON public.users FOR SELECT USING (true);
CREATE POLICY "Users insert"      ON public.users FOR INSERT WITH CHECK (true);
CREATE POLICY "Users update"      ON public.users FOR UPDATE USING (true);


-- ============================================================
-- 2. MENTORS TABLE
-- ============================================================
CREATE TABLE IF NOT EXISTS public.mentors (
  id               UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  created_at       TIMESTAMPTZ DEFAULT NOW(),
  full_name        TEXT NOT NULL,
  email            TEXT UNIQUE NOT NULL,
  phone            TEXT,
  linkedin         TEXT,
  bio              TEXT,
  expertise        TEXT[]       DEFAULT '{}',
  current_position TEXT         DEFAULT '',
  availability     BOOLEAN      DEFAULT TRUE,
  rating           NUMERIC(3,1) DEFAULT 0,
  avatar           TEXT,
  is_verified      BOOLEAN      DEFAULT FALSE,
  video_url        TEXT
);

ALTER TABLE public.mentors ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Mentors select all"  ON public.mentors FOR SELECT USING (true);
CREATE POLICY "Mentors insert"      ON public.mentors FOR INSERT WITH CHECK (true);
CREATE POLICY "Mentors update"      ON public.mentors FOR UPDATE USING (true);


-- ============================================================
-- 3. USER QUIZ DATA TABLE
-- ============================================================
CREATE TABLE IF NOT EXISTS public."userQuizData" (
  id                    BIGSERIAL PRIMARY KEY,
  created_at            TIMESTAMPTZ DEFAULT NOW(),
  "userId"              TEXT NOT NULL,
  "quizInfo"            JSONB DEFAULT '{}',
  "user_current_status" TEXT DEFAULT '',
  "user_mainFocus"      TEXT DEFAULT '',
  "userName"            TEXT DEFAULT '',
  "userAvatar"          TEXT DEFAULT '',
  "selectedCareer"      TEXT DEFAULT ''
);

ALTER TABLE public."userQuizData" ENABLE ROW LEVEL SECURITY;

CREATE POLICY "QuizData select" ON public."userQuizData" FOR SELECT USING (true);
CREATE POLICY "QuizData insert" ON public."userQuizData" FOR INSERT WITH CHECK (true);
CREATE POLICY "QuizData update" ON public."userQuizData" FOR UPDATE USING (true);


-- ============================================================
-- 4. COLLEGES TABLE
-- ============================================================
CREATE TABLE IF NOT EXISTS public.colleges (
  id            BIGSERIAL PRIMARY KEY,
  created_at    TIMESTAMPTZ DEFAULT NOW(),
  college_name  TEXT NOT NULL,
  location      TEXT NOT NULL,
  best_suit_for TEXT[]  DEFAULT '{}',
  fees          TEXT    DEFAULT '',
  placement     TEXT    DEFAULT '',
  type          TEXT    DEFAULT 'private'
);

ALTER TABLE public.colleges ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Colleges select" ON public.colleges FOR SELECT USING (true);
CREATE POLICY "Colleges insert" ON public.colleges FOR INSERT WITH CHECK (true);


-- ============================================================
-- 5. MENTOR SESSIONS TABLE
-- ============================================================
CREATE TABLE IF NOT EXISTS public.mentor_sessions (
  id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  created_at     TIMESTAMPTZ DEFAULT NOW(),
  mentor_id      UUID NOT NULL REFERENCES public.mentors(id) ON DELETE CASCADE,
  student_id     TEXT NOT NULL,
  session_type   TEXT NOT NULL DEFAULT '30 min session',
  status         TEXT DEFAULT 'pending',
  requested_at   TIMESTAMPTZ DEFAULT NOW(),
  scheduled_at   TIMESTAMPTZ,
  completed_at   TIMESTAMPTZ,
  notes          TEXT,
  vc_link        TEXT,
  reviews        TEXT,
  "mentorName"   TEXT DEFAULT '',
  "mentorAvatar" TEXT
);

ALTER TABLE public.mentor_sessions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Sessions select" ON public.mentor_sessions FOR SELECT USING (true);
CREATE POLICY "Sessions insert" ON public.mentor_sessions FOR INSERT WITH CHECK (true);
CREATE POLICY "Sessions update" ON public.mentor_sessions FOR UPDATE USING (true);
CREATE POLICY "Sessions delete" ON public.mentor_sessions FOR DELETE USING (true);

ALTER PUBLICATION supabase_realtime ADD TABLE public.mentor_sessions;


-- ============================================================
-- 6. ROADMAP USERS TABLE
-- ============================================================
CREATE TABLE IF NOT EXISTS public."roadmapUsers" (
  id            BIGSERIAL PRIMARY KEY,
  created_at    TIMESTAMPTZ DEFAULT NOW(),
  user_id       TEXT NOT NULL,
  roadmap_data  JSONB    DEFAULT '{}',
  "isStarted"   BOOLEAN  DEFAULT FALSE,
  timeline      TEXT     DEFAULT '',
  mode          TEXT     DEFAULT '',
  status        TEXT     DEFAULT 'not_started',
  progress      INTEGER  DEFAULT 0
);

ALTER TABLE public."roadmapUsers" ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Roadmaps select" ON public."roadmapUsers" FOR SELECT USING (true);
CREATE POLICY "Roadmaps insert" ON public."roadmapUsers" FOR INSERT WITH CHECK (true);
CREATE POLICY "Roadmaps update" ON public."roadmapUsers" FOR UPDATE USING (true);


-- ============================================================
-- 7. TRACKS TABLE (learning checkpoints)
-- ============================================================
CREATE TABLE IF NOT EXISTS public.tracks (
  id           BIGSERIAL PRIMARY KEY,
  created_at   TIMESTAMPTZ DEFAULT NOW(),
  roadmap_id   BIGINT NOT NULL REFERENCES public."roadmapUsers"(id) ON DELETE CASCADE,
  user_id      TEXT NOT NULL,
  checkpoints  JSONB DEFAULT '[]'
);

ALTER TABLE public.tracks ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Tracks select" ON public.tracks FOR SELECT USING (true);
CREATE POLICY "Tracks insert" ON public.tracks FOR INSERT WITH CHECK (true);
CREATE POLICY "Tracks update" ON public.tracks FOR UPDATE USING (true);


-- ============================================================
-- 8. JOB TRACKER TABLE
-- ============================================================
CREATE TABLE IF NOT EXISTS public.job_tracker (
  id            BIGSERIAL PRIMARY KEY,
  created_at    TIMESTAMPTZ DEFAULT NOW(),
  "userId"      TEXT NOT NULL,
  stage         TEXT  DEFAULT 'saved',
  job_title     TEXT  NOT NULL DEFAULT '',
  company       TEXT  DEFAULT '',
  applied_date  DATE,
  type          TEXT  DEFAULT 'full-time',
  description   TEXT  DEFAULT '',
  note          TEXT  DEFAULT ''
);

ALTER TABLE public.job_tracker ENABLE ROW LEVEL SECURITY;

CREATE POLICY "JobTracker select" ON public.job_tracker FOR SELECT USING (true);
CREATE POLICY "JobTracker insert" ON public.job_tracker FOR INSERT WITH CHECK (true);
CREATE POLICY "JobTracker update" ON public.job_tracker FOR UPDATE USING (true);
CREATE POLICY "JobTracker delete" ON public.job_tracker FOR DELETE USING (true);


-- ============================================================
-- 9. OTHERS TABLE (interview feedback / AI insights)
-- ============================================================
CREATE TABLE IF NOT EXISTS public.others (
  id                   BIGSERIAL PRIMARY KEY,
  created_at           TIMESTAMPTZ DEFAULT NOW(),
  "userId"             TEXT NOT NULL,
  "jobTitle"           TEXT DEFAULT '',
  "interviewInsights"  JSONB DEFAULT '{}'
);

ALTER TABLE public.others ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Others select" ON public.others FOR SELECT USING (true);
CREATE POLICY "Others insert" ON public.others FOR INSERT WITH CHECK (true);


-- ============================================================
-- 10. NOTIFICATION TABLE
-- ============================================================
CREATE TABLE IF NOT EXISTS public.notification (
  id         BIGSERIAL PRIMARY KEY,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  "userId"   TEXT NOT NULL,
  message    TEXT NOT NULL DEFAULT ''
);

ALTER TABLE public.notification ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Notification select" ON public.notification FOR SELECT USING (true);
CREATE POLICY "Notification insert" ON public.notification FOR INSERT WITH CHECK (true);

ALTER PUBLICATION supabase_realtime ADD TABLE public.notification;


-- ============================================================
-- 11. MESSAGES TABLE (real-time direct messages)
-- ============================================================
CREATE TABLE IF NOT EXISTS public.messages (
  id            BIGSERIAL PRIMARY KEY,
  created_at    TIMESTAMPTZ DEFAULT NOW(),
  sender_id     TEXT NOT NULL,
  receiver_id   TEXT NOT NULL,
  receiver_type TEXT DEFAULT 'user',
  content       TEXT NOT NULL DEFAULT ''
);

ALTER TABLE public.messages ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Messages select" ON public.messages FOR SELECT USING (true);
CREATE POLICY "Messages insert" ON public.messages FOR INSERT WITH CHECK (true);

ALTER PUBLICATION supabase_realtime ADD TABLE public.messages;


-- ============================================================
-- 12. USER CALENDAR TABLE
-- ============================================================
CREATE TABLE IF NOT EXISTS public."userCalendar" (
  id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  created_at      TIMESTAMPTZ DEFAULT NOW(),
  updated_at      TIMESTAMPTZ DEFAULT NOW(),
  user_id         TEXT NOT NULL,
  title           TEXT NOT NULL DEFAULT '',
  start_time      TIMESTAMPTZ NOT NULL,
  end_time        TIMESTAMPTZ NOT NULL,
  google_event_id TEXT
);

ALTER TABLE public."userCalendar" ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Calendar select" ON public."userCalendar" FOR SELECT USING (true);
CREATE POLICY "Calendar insert" ON public."userCalendar" FOR INSERT WITH CHECK (true);
CREATE POLICY "Calendar update" ON public."userCalendar" FOR UPDATE USING (true);
CREATE POLICY "Calendar delete" ON public."userCalendar" FOR DELETE USING (true);


-- ============================================================
-- STORAGE BUCKET for avatars
-- ============================================================
INSERT INTO storage.buckets (id, name, public)
VALUES ('avatars', 'avatars', true)
ON CONFLICT (id) DO NOTHING;

CREATE POLICY "Avatars public read"
  ON storage.objects FOR SELECT USING (bucket_id = 'avatars');

CREATE POLICY "Avatars upload"
  ON storage.objects FOR INSERT WITH CHECK (bucket_id = 'avatars');


-- ============================================================
-- SEED DATA: MENTORS
-- ============================================================
INSERT INTO public.mentors (full_name, email, current_position, expertise, bio, rating, availability, is_verified) VALUES
  ('Aditya Sharma',   'aditya.sharma@mentor.dev',   'Senior Software Engineer',    ARRAY['software engineer','backend engineer','python','system design'],          'Ex-Google SWE with 8+ years building scalable backend systems.', 4.8, true, true),
  ('Priya Mehta',     'priya.mehta@mentor.dev',     'Data Scientist at Microsoft', ARRAY['data scientist','ml engineer','ai engineer','machine learning','python'], 'MS in AI from IIT Delhi. Working at Microsoft Research.', 4.9, true, true),
  ('Rahul Verma',     'rahul.verma@mentor.dev',     'Frontend Engineer',           ARRAY['frontend engineer','react','typescript','ui/ux'],                        'Building beautiful products at Razorpay. 5 years React experience.', 4.7, true, true),
  ('Sneha Patel',     'sneha.patel@mentor.dev',     'Product Manager at Flipkart', ARRAY['product manager','agile','strategy','analytics'],                        'PM with 6 years experience at top Indian startups. MBA from IIM-A.', 4.6, true, true),
  ('Karan Gupta',     'karan.gupta@mentor.dev',     'ML Engineer at OpenAI',       ARRAY['ml engineer','ai engineer','deep learning','llm','python'],               'Working on frontier AI models. PhD from Stanford. Ex-DeepMind.', 5.0, true, true),
  ('Ananya Nair',     'ananya.nair@mentor.dev',     'Cybersecurity Analyst',       ARRAY['ethical hacker','cybersecurity analyst','network security','pentesting'], 'OSCP certified. 7 years securing enterprise infrastructure.', 4.5, true, true),
  ('Vikram Singh',    'vikram.singh@mentor.dev',    'Full Stack Engineer',          ARRAY['software engineer','full stack engineer','nodejs','react','aws'],         'CTO at an early-stage startup. Previously at Amazon. Loves open source.', 4.7, true, true),
  ('Meera Krishnan',  'meera.krishnan@mentor.dev',  'Data Engineer at Swiggy',     ARRAY['data engineer','backend engineer','spark','airflow','bigquery'],          'Building real-time data pipelines. Ex-Ola, Ex-Zomato.', 4.8, true, true)
ON CONFLICT (email) DO NOTHING;

-- ============================================================
-- SEED DATA: COLLEGES
-- ============================================================
INSERT INTO public.colleges (college_name, location, best_suit_for, fees, placement, type) VALUES
  ('IIT Bombay',            'Mumbai, Maharashtra',         ARRAY['engineering','technology','cs','software','data','ai'], '₹2.2L/year', '₹16-22 LPA avg', 'government'),
  ('IIT Delhi',             'New Delhi, Delhi',            ARRAY['engineering','technology','cs','software','data','ai'], '₹2.2L/year', '₹18-25 LPA avg', 'government'),
  ('IIT Madras',            'Chennai, Tamil Nadu',         ARRAY['engineering','technology','cs','software','data','ai'], '₹2.2L/year', '₹16-24 LPA avg', 'government'),
  ('BITS Pilani',           'Pilani, Rajasthan',           ARRAY['engineering','technology','cs','software'],             '₹5L/year',   '₹14-20 LPA avg', 'deemed'),
  ('NIT Trichy',            'Tiruchirappalli, Tamil Nadu', ARRAY['engineering','technology','cs','software'],             '₹1.5L/year', '₹10-15 LPA avg', 'government'),
  ('VIT Vellore',           'Vellore, Tamil Nadu',         ARRAY['engineering','technology','cs','software'],             '₹3.5L/year', '₹8-14 LPA avg',  'private'),
  ('Amity University',      'Mumbai, Maharashtra',         ARRAY['management','business','commerce','marketing'],         '₹4L/year',   '₹6-12 LPA avg',  'private'),
  ('IIM Ahmedabad',         'Ahmedabad, Gujarat',          ARRAY['management','mba','business','finance'],                '₹25L total', '₹28-35 LPA avg', 'government'),
  ('IIM Bangalore',         'Bengaluru, Karnataka',        ARRAY['management','mba','business','finance'],                '₹24L total', '₹26-34 LPA avg', 'government'),
  ('XLRI Jamshedpur',       'Jamshedpur, Jharkhand',       ARRAY['management','mba','hr','business'],                    '₹20L total', '₹22-28 LPA avg', 'private'),
  ('Christ University',     'Bengaluru, Karnataka',        ARRAY['arts','commerce','science','law','psychology'],         '₹2.5L/year', '₹5-10 LPA avg',  'deemed'),
  ('Delhi University',      'New Delhi, Delhi',            ARRAY['arts','commerce','science','humanities'],               '₹30K/year',  '₹5-10 LPA avg',  'government'),
  ('Symbiosis Pune',        'Pune, Maharashtra',           ARRAY['management','law','media','design','it'],               '₹3.5L/year', '₹8-14 LPA avg',  'deemed'),
  ('Manipal Academy',       'Manipal, Karnataka',          ARRAY['engineering','medicine','design','management'],         '₹4L/year',   '₹8-15 LPA avg',  'private'),
  ('SRM Institute',         'Chennai, Tamil Nadu',         ARRAY['engineering','technology','cs','software'],             '₹3L/year',   '₹7-12 LPA avg',  'private'),
  ('Jadavpur University',   'Kolkata, West Bengal',        ARRAY['engineering','technology','cs','arts'],                 '₹25K/year',  '₹10-18 LPA avg', 'government'),
  ('Anna University',       'Chennai, Tamil Nadu',         ARRAY['engineering','technology','cs','software'],             '₹50K/year',  '₹8-14 LPA avg',  'government'),
  ('Pune University',       'Pune, Maharashtra',           ARRAY['engineering','commerce','science','arts'],              '₹80K/year',  '₹7-12 LPA avg',  'government'),
  ('Osmania University',    'Hyderabad, Telangana',        ARRAY['engineering','arts','commerce','science'],              '₹40K/year',  '₹6-10 LPA avg',  'government'),
  ('LPU',                   'Phagwara, Punjab',            ARRAY['engineering','management','design','cs'],               '₹2.5L/year', '₹6-12 LPA avg',  'private')
ON CONFLICT DO NOTHING;

-- ============================================================
-- ALL DONE! 12 tables created + seed data inserted.
-- ============================================================
