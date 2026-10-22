# Wayfare VPN (demo) - Android project

This is a DEMO interface. It does not create a VPN tunnel, encrypt, or reroute traffic.
The in-app Declaration says so. Please keep it in place.

## Build an APK (Capacitor + Android Studio)

You need: Node.js (LTS) and Android Studio.

1. Open a terminal in this folder and run:
   npm install @capacitor/core @capacitor/android
   npm install -D @capacitor/cli
2. Add the Android project:
   npx cap add android
   npx cap sync android
3. Open it in Android Studio:
   npx cap open android
4. In Android Studio: Build > Build Bundle(s) / APK(s) > Build APK(s).
   The debug APK lands in android/app/build/outputs/apk/debug/app-debug.apk
5. Copy that file to your phone and install it (allow "install unknown apps" when asked).

Change the app id in capacitor.config.json (com.example.wayfaredemo) before you build
if you want your own package name.

## No Android Studio?
The whole app is one file: www/index.html. Online web-to-APK converters
(for example PWABuilder or WebIntoApp) accept that file or a zip of it.

## Note
Real VPN apps on Android must use the system VpnService API and a real server network.
Google Play also has extra rules for VPN apps, so this demo is for personal use only.
