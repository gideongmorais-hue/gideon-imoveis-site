create extension if not exists pgcrypto;
create table if not exists public.properties (
  id uuid primary key default gen_random_uuid(),
  title text not null,
  property_type text not null default 'Apartamento',
  price numeric not null default 0,
  city text,
  neighborhood text,
  bedrooms integer not null default 0,
  suites integer not null default 0,
  bathrooms integer not null default 0,
  parking_spaces integer not null default 0,
  area_m2 numeric not null default 0,
  description text,
  youtube_url text,
  images text[] not null default '{}',
  status text not null default 'Disponível',
  featured boolean not null default false,
  published boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
alter table public.properties enable row level security;
drop policy if exists "Public read published" on public.properties;
create policy "Public read published" on public.properties for select using (published = true or auth.role() = 'authenticated');
drop policy if exists "Admin insert" on public.properties;
create policy "Admin insert" on public.properties for insert to authenticated with check (true);
drop policy if exists "Admin update" on public.properties;
create policy "Admin update" on public.properties for update to authenticated using (true) with check (true);
drop policy if exists "Admin delete" on public.properties;
create policy "Admin delete" on public.properties for delete to authenticated using (true);
insert into storage.buckets (id,name,public) values ('property-images','property-images',true) on conflict (id) do update set public=true;
drop policy if exists "Public view images" on storage.objects;
create policy "Public view images" on storage.objects for select using (bucket_id='property-images');
drop policy if exists "Admin upload images" on storage.objects;
create policy "Admin upload images" on storage.objects for insert to authenticated with check (bucket_id='property-images');
drop policy if exists "Admin update images" on storage.objects;
create policy "Admin update images" on storage.objects for update to authenticated using (bucket_id='property-images') with check (bucket_id='property-images');
drop policy if exists "Admin delete images" on storage.objects;
create policy "Admin delete images" on storage.objects for delete to authenticated using (bucket_id='property-images');
