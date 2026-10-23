# Wayfare VPN (demo)

A prototype of a VPN app's interface, packaged for Android with Capacitor.

**This is a demo. It does not create a VPN tunnel, encrypt, or reroute any traffic.**
The in-app Declaration says so. Please keep it in place.

## Get the APK from GitHub (no Android Studio needed)

1. Push this repo to GitHub (branch `main`).
2. Open the **Actions** tab, then **Build APK**. It runs on every push, or press **Run workflow**.
3. When it finishes, open the run and download **wayfare-vpn-demo-apk** under *Artifacts*.
4. Unzip it, copy `app-debug.apk` to your phone and install it (allow "install unknown apps").

## Build locally instead

    npm install
    npx cap add android
    npx cap sync android
    npx cap open android      # then Build > Build APK(s)

Change `appId` in `capacitor.config.json` (`com.example.wayfaredemo`) if you want your own package name.

## Notes

- The app is one file: `www/index.html`.
- Real Android VPN apps must use the system `VpnService` API and a real server network.
  Google Play has extra rules for VPN apps, so this demo is for personal use only.
