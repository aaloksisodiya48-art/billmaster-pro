-- DukaanLink cloud database (Supabase / PostgreSQL)
-- Run this entire file once in Supabase SQL Editor.
create extension if not exists pgcrypto;

create or replace function public.set_updated_at()
returns trigger language plpgsql as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

create table if not exists public.shop_profiles (
  owner_id uuid primary key references auth.users(id) on delete cascade,
  shop_name text not null default '',
  owner_name text not null default '',
  whatsapp text not null default '',
  address text not null default '',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.products (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null references auth.users(id) on delete cascade,
  name text not null check (length(trim(name)) between 1 and 160),
  price numeric(12,2) not null check (price >= 0),
  quantity integer not null default 0 check (quantity >= 0),
  low_stock_threshold integer not null default 5 check (low_stock_threshold >= 0),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.orders (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null references auth.users(id) on delete cascade,
  customer_name text not null check (length(trim(customer_name)) between 1 and 160),
  customer_whatsapp text not null default '',
  product_name text not null,
  product_id uuid,
  quantity integer not null check (quantity > 0),
  total numeric(12,2) not null check (total >= 0),
  payment_status text not null default 'Pending' check (payment_status in ('Paid','Pending')),
  order_status text not null default 'New' check (order_status in ('New','Processing','Completed','Cancelled')),
  note text not null default '',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create table if not exists public.expenses (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid not null references auth.users(id) on delete cascade,
  title text not null check (length(trim(title)) between 1 and 160),
  amount numeric(12,2) not null check (amount > 0),
  category text not null default 'Other',
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists products_owner_created_idx on public.products(owner_id, created_at desc);
create index if not exists orders_owner_created_idx on public.orders(owner_id, created_at desc);
create index if not exists expenses_owner_created_idx on public.expenses(owner_id, created_at desc);

drop trigger if exists shop_profiles_updated_at on public.shop_profiles;
create trigger shop_profiles_updated_at before update on public.shop_profiles
for each row execute function public.set_updated_at();
drop trigger if exists products_updated_at on public.products;
create trigger products_updated_at before update on public.products
for each row execute function public.set_updated_at();
drop trigger if exists orders_updated_at on public.orders;
create trigger orders_updated_at before update on public.orders
for each row execute function public.set_updated_at();
drop trigger if exists expenses_updated_at on public.expenses;
create trigger expenses_updated_at before update on public.expenses
for each row execute function public.set_updated_at();

alter table public.shop_profiles enable row level security;
alter table public.products enable row level security;
alter table public.orders enable row level security;
alter table public.expenses enable row level security;

drop policy if exists "Owner manages own shop profile" on public.shop_profiles;
create policy "Owner manages own shop profile" on public.shop_profiles
for all to authenticated using (owner_id = auth.uid()) with check (owner_id = auth.uid());

drop policy if exists "Owner manages own products" on public.products;
create policy "Owner manages own products" on public.products
for all to authenticated using (owner_id = auth.uid()) with check (owner_id = auth.uid());

drop policy if exists "Owner manages own orders" on public.orders;
create policy "Owner manages own orders" on public.orders
for all to authenticated using (owner_id = auth.uid()) with check (owner_id = auth.uid());

drop policy if exists "Owner manages own expenses" on public.expenses;
create policy "Owner manages own expenses" on public.expenses
for all to authenticated using (owner_id = auth.uid()) with check (owner_id = auth.uid());

grant usage on schema public to authenticated;
grant select, insert, update, delete on public.shop_profiles, public.products, public.orders, public.expenses to authenticated;
