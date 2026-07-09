-- משב-ארדן מערכות | יומן קבלן חודשי
create table if not exists public.contractor_daily_logs (
  id text primary key,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  sort_order numeric default 999999,
  log_date date not null,
  day_name text,
  month_key text,
  project_number text not null,
  project_name text not null,
  contractor_name text not null,
  contractor_manager text,
  contractor_phone text,
  tower text,
  floor text,
  area text,
  room text,
  workers jsonb not null default '[]'::jsonb,
  planned_work text,
  done_work text,
  quantities text,
  notes text,
  next_tasks text,
  tasks jsonb not null default '[]'::jsonb,
  start_time text,
  end_time text,
  break_minutes numeric default 0,
  approved_hours numeric default 0,
  payment_type text,
  rate numeric default 0,
  amount numeric default 0,
  status text default 'טיוטה',
  supervisor_name text,
  supervisor_role text,
  approval_note text,
  user_email text
);

alter table public.contractor_daily_logs enable row level security;

drop policy if exists "contractor logs select authenticated" on public.contractor_daily_logs;
create policy "contractor logs select authenticated" on public.contractor_daily_logs for select to authenticated using (((auth.jwt() ->> 'email') ilike '%@mashav-ardan.co.il'));

drop policy if exists "contractor logs insert authenticated" on public.contractor_daily_logs;
create policy "contractor logs insert authenticated" on public.contractor_daily_logs for insert to authenticated with check (((auth.jwt() ->> 'email') ilike '%@mashav-ardan.co.il'));

drop policy if exists "contractor logs update authenticated" on public.contractor_daily_logs;
create policy "contractor logs update authenticated" on public.contractor_daily_logs for update to authenticated using (((auth.jwt() ->> 'email') ilike '%@mashav-ardan.co.il')) with check (((auth.jwt() ->> 'email') ilike '%@mashav-ardan.co.il'));

drop policy if exists "contractor logs delete authenticated" on public.contractor_daily_logs;
create policy "contractor logs delete authenticated" on public.contractor_daily_logs for delete to authenticated using (((auth.jwt() ->> 'email') ilike '%@mashav-ardan.co.il'));

create index if not exists contractor_daily_logs_project_idx on public.contractor_daily_logs(project_number);
create index if not exists contractor_daily_logs_month_idx on public.contractor_daily_logs(month_key);
create index if not exists contractor_daily_logs_date_idx on public.contractor_daily_logs(log_date desc);
create index if not exists contractor_daily_logs_sort_idx on public.contractor_daily_logs(sort_order);
create index if not exists contractor_daily_logs_contractor_idx on public.contractor_daily_logs(contractor_name);


-- הערת התחברות:
-- כדי שמשתמשים חדשים עם @mashav-ardan.co.il יוכלו להיכנס,
-- יש לאפשר Signups ב-Supabase Auth.
-- אם Confirm Email פעיל, הם יצטרכו לאשר מייל לפני כניסה ראשונה.
