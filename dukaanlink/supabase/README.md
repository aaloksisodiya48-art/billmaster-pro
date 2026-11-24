# DukaanLink cloud backend setup

DukaanLink currently runs as a static GitHub Pages app. GitHub Pages cannot run a private API server or database. This folder prepares a Supabase-hosted PostgreSQL backend with Supabase Auth and Row Level Security.

## What is ready
- `schema.sql`: tables for shop profiles, products, orders and expenses.
- Every row is scoped to its authenticated owner using RLS policies.
- Constraints validate prices, quantities and allowed order/payment statuses.
- The current app is still local-browser storage until its frontend is connected to a real Supabase project. Do not assume cloud sync is active yet.

## Create the hosted backend
1. Open https://supabase.com/ and create a project.
2. Save the database password somewhere private. Do not paste it into chat or commit it to GitHub.
3. In the Supabase project, open **SQL Editor → New query**.
4. Copy all contents of `schema.sql`, paste them into the editor, and click **Run**.
5. Open **Project Settings → API** (or **Data API**) and copy the Project URL and the publishable/anon key.
6. Keep the project URL and publishable/anon key available for the frontend connection step. Never use or share the `service_role` key in browser code.

## Before using real customer data
- Enable email/password sign-in in Authentication → Providers.
- Configure the allowed redirect/site URL to the deployed DukaanLink URL.
- Keep email confirmation enabled if you want verified accounts.
- Test with two separate accounts and confirm each account can only see its own rows.
- Do not disable RLS. Do not add public read/write policies to the owner tables.

## Current limitations
The SQL creates the hosted database structure, but it does not provision a Supabase project or connect the current dashboard automatically. A project URL and publishable/anon key are required for that next integration step. Existing localStorage data will need an explicit import/migration flow; it is not automatically uploaded.
