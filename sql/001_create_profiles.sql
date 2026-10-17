-- 001_create_profiles.sql
-- إنشاء جدول profiles وتفعيل سياسات RLS اللازمة

create table if not exists public.profiles (
  id uuid primary key,
  balance numeric default 0,
  last_run timestamptz
);

-- تفعيل Row Level Security
alter table public.profiles enable row level security;

-- سياسة قراءة الملف الشخصي للمستخدم المصادق عليه فقط
create policy if not exists select_own_profile on public.profiles
  for select using ( auth.uid() = id );

-- سياسة الإدراج: يسمح للمستخدم المصادق عليه بإدراج ملفه الشخصي
create policy if not exists insert_profiles on public.profiles
  for insert with check ( auth.uid() = id );

-- سياسة التحديث للمستخدم المصادق عليه فقط
create policy if not exists update_own_profile on public.profiles
  for update using ( auth.uid() = id ) with check ( auth.uid() = id );
