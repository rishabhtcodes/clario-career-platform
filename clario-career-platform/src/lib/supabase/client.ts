import { createBrowserClient } from "@supabase/ssr";

export function createClient() {
  const url = process.env.NEXT_PUBLIC_SUPABASE_URL;
  const key = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY;

  if (
    !url ||
    !key ||
    url === "https://placeholder.supabase.co" ||
    key === "placeholder_anon_key"
  ) {
    console.warn(
      "⚠️ Supabase is not configured. Please set NEXT_PUBLIC_SUPABASE_URL and NEXT_PUBLIC_SUPABASE_ANON_KEY in .env.local"
    );
    return null as unknown as ReturnType<typeof createBrowserClient>;
  }

  return createBrowserClient(url, key);
}