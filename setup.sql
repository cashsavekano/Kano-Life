-- Run this in Supabase Dashboard > SQL Editor > New query.
-- This table stores one cloud save per authenticated player.
create table if not exists public.game_saves (
  user_id uuid primary key references auth.users(id) on delete cascade,
  save_data jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

alter table public.game_saves enable row level security;

drop policy if exists "Players can read their own save" on public.game_saves;
create policy "Players can read their own save"
on public.game_saves for select to authenticated
using (auth.uid() = user_id);

drop policy if exists "Players can insert their own save" on public.game_saves;
create policy "Players can insert their own save"
on public.game_saves for insert to authenticated
with check (auth.uid() = user_id);

drop policy if exists "Players can update their own save" on public.game_saves;
create policy "Players can update their own save"
on public.game_saves for update to authenticated
using (auth.uid() = user_id)
with check (auth.uid() = user_id);
