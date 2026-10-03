-- NOTFOME · FASE 2 · NUBE + GOOGLE
-- Ejecutar completo en Supabase > SQL Editor.
-- La autenticación por Google se habilita desde Authentication > Providers.

create table if not exists public.notfome_profiles (
  user_id uuid primary key references auth.users(id) on delete cascade,
  business_name text not null default '',
  logo_data text not null default '',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.notfome_user_data (
  user_id uuid primary key references auth.users(id) on delete cascade,
  data jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

alter table public.notfome_profiles enable row level security;
alter table public.notfome_user_data enable row level security;

-- Cada cuenta solamente puede leer/modificar sus propios datos.
drop policy if exists "Users can read own profile" on public.notfome_profiles;
drop policy if exists "Users can insert own profile" on public.notfome_profiles;
drop policy if exists "Users can update own profile" on public.notfome_profiles;
create policy "Users can read own profile" on public.notfome_profiles for select to authenticated using (auth.uid() = user_id);
create policy "Users can insert own profile" on public.notfome_profiles for insert to authenticated with check (auth.uid() = user_id);
create policy "Users can update own profile" on public.notfome_profiles for update to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);

drop policy if exists "Users can read own NOT data" on public.notfome_user_data;
drop policy if exists "Users can insert own NOT data" on public.notfome_user_data;
drop policy if exists "Users can update own NOT data" on public.notfome_user_data;
create policy "Users can read own NOT data" on public.notfome_user_data for select to authenticated using (auth.uid() = user_id);
create policy "Users can insert own NOT data" on public.notfome_user_data for insert to authenticated with check (auth.uid() = user_id);
create policy "Users can update own NOT data" on public.notfome_user_data for update to authenticated using (auth.uid() = user_id) with check (auth.uid() = user_id);

create index if not exists notfome_user_data_updated_at_idx on public.notfome_user_data(updated_at);
create index if not exists notfome_profiles_updated_at_idx on public.notfome_profiles(updated_at);

-- Crea automáticamente el perfil cuando una cuenta de Google se registra.
create or replace function public.handle_new_notfome_user()
returns trigger
language plpgsql
security definer set search_path = public
as $$
begin
  insert into public.notfome_profiles (user_id, business_name, logo_data)
  values (
    new.id,
    coalesce(new.raw_user_meta_data->>'name', ''),
    ''
  )
  on conflict (user_id) do nothing;
  return new;
end;
$$;

drop trigger if exists on_auth_user_created_notfome on auth.users;
create trigger on_auth_user_created_notfome
after insert on auth.users
for each row execute procedure public.handle_new_notfome_user();

-- Actualiza updated_at del perfil automáticamente.
create or replace function public.set_notfome_profile_updated_at()
returns trigger
language plpgsql
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

drop trigger if exists notfome_profiles_updated_at on public.notfome_profiles;
create trigger notfome_profiles_updated_at
before update on public.notfome_profiles
for each row execute procedure public.set_notfome_profile_updated_at();

-- NOTA: no hay service_role key en la aplicación.
-- La clave pública del frontend es segura solamente porque RLS limita cada fila a auth.uid().
