# DukaanLink cloud backend setup

The dashboard now includes Supabase email/password authentication and an explicit first-time upload/download choice. After choosing one, it syncs shop profile, products, orders and expenses to the signed-in account.

## One-time Supabase setup (required)
1. In your Supabase project, open **SQL Editor → New query**.
2. Open this repository file: `dukaanlink/supabase/schema.sql`. Copy the entire file into the SQL Editor and click **Run**.
3. In **Authentication → Providers**, enable **Email** sign-in.
4. In **Authentication → URL Configuration**, set the Site URL to:
   `https://aaloksisodiya48-art.github.io/billmaster-pro/dukaanlink/`
   Add that same URL to the allowed redirect URLs if required.
5. If email confirmation is enabled, confirm the signup email before signing in.

## Frontend key safety
- `dukaanlink/config.js` contains the Project URL and Supabase publishable key. Publishable keys are intended for browser apps.
- Never put a database password, `service_role`, or secret key in frontend code or GitHub.
- Row Level Security (RLS) is enabled by the schema. Keep it enabled; the policies restrict every row to its authenticated owner.

## First login and migration
1. Open the DukaanLink dashboard and go to **Shop profile → Cloud backup & sync**.
2. Create an account or sign in.
3. Choose **Upload this device's data** to migrate the current browser's local data to your cloud account, or **Load cloud data here** to use data already in Supabase.
4. The selected action enables automatic sync on that device. Sign in and choose the action on each additional device.

**Important:** Export a backup before migration. Upload replaces the cloud records for that account; download replaces local browser data. The customer storefront still uses a shareable catalogue snapshot link, and WhatsApp orders are not automatically inserted into the dashboard.
