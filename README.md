# Veil for Android

A small WireGuard client. It uses the official `com.wireguard.android:tunnel`
library, the same engine as the WireGuard app. It was not compiled or tested
where it was written, so expect to fix a small thing or two on first build.

## Build the APK
1. Install Android Studio (free) on a computer.
2. File > Open, choose this `veil-android` folder, and let Gradle sync.
   (Accept any prompt to download the SDK or use the default Gradle.)
3. Build > Build Bundle(s) / APK(s) > Build APK(s).
4. The file is at `app/build/outputs/apk/debug/app-debug.apk`.
5. Copy it to your phone and allow "Install unknown apps" for your file manager.
   Or plug the phone in with USB debugging on and press Run.

## Use it
1. Set up a server with `setup-wireguard.sh` (see that file).
2. Paste the contents of `/root/veil-client.conf` into the app and tap Connect.
3. Approve Android's one-time "Connection request" dialog.

## Kill switch
Android does this at system level: Settings > Network > VPN > Veil >
turn on "Always-on VPN" and "Block connections without VPN".

## Notes
- The config, including your private key, is stored in the app's private storage.
  For a release build, move it to EncryptedSharedPreferences or the Android Keystore.
- One server only. IPv6 is routed into the tunnel and dropped by the server,
  which prevents IPv6 leaks.
