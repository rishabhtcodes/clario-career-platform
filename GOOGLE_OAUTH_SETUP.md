# Google OAuth Setup Guide for Clario

This file documents the steps required to configure Google Login for the Clario platform via Supabase. 
When you are ready to proceed with these steps, just let me know and I will guide you through or we can try using the automated tools again if the network proxy is unblocked.

## Phase 1: Obtain Google Cloud Credentials
1. Navigate to the [Google Cloud Console - Credentials Page](https://console.cloud.google.com/apis/credentials).
2. Ensure you have a project selected (or create a new one).
3. Click **Create Credentials** -> **OAuth client ID**.
   *(Note: If prompted to configure the "Consent Screen" first, select "External", fill in the App Name ("Clario") and your email addresses, then save through to the end).*
4. For Application Type, select **Web application**.
5. Under **Authorized redirect URIs**, click "Add URI" and paste the exact Supabase callback URL:
   `https://veiucmeaejlvcofkoide.supabase.co/auth/v1/callback`
6. Click **Create**.
7. Google will display a modal with your **Client ID** and **Client Secret**. Keep this modal open or copy these values.

## Phase 2: Configure Supabase
1. Open your Supabase Project Dashboard and navigate to [Auth Providers Settings](https://supabase.com/dashboard/project/veiucmeaejlvcofkoide/auth/providers).
2. In the list of providers, click on **Google** to expand its settings.
3. Toggle **Enable Sign in with Google** to ON.
4. Paste the **Client ID** and **Client Secret** obtained from Phase 1 into their respective fields.
5. Click **Save**.

## Phase 3: Final Verification
1. Open `http://localhost:3000/auth` in your browser.
2. Click the **"continue with Google"** button.
3. You should be redirected to the Google login screen, and upon authenticating, successfully routed to the `/home` dashboard.

---
*Status: Pending user action.*
*Next Steps: Once these keys are configured in Supabase, Google OAuth will work natively with the existing codebase.*
