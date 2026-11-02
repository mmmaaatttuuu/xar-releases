# XAR for Windows

Signed Windows x64 releases for XAR. **GitHub sign-in is not required for updates
in XAR 2.0.3 and later.** Your AI providers still use their own local sign-ins.

## Downloads

- [XAR.exe](https://github.com/mmmaaatttuuu/xar-releases/releases/latest/download/XAR.exe) — current app.
- [XAR-Upgrader.exe](https://github.com/mmmaaatttuuu/xar-releases/releases/latest/download/XAR-Upgrader.exe) — one-time upgrade for old copies stuck at GitHub login.
- [Release notes](https://github.com/mmmaaatttuuu/xar-releases/releases/latest).

Windows 10/11 x64 and Microsoft Edge WebView2 are required for the native app.

## Already using XAR?

If your old copy can already access GitHub, close and reopen it. The original
repository address and signing key are unchanged, so its existing updater can
install the transition release.

If it asks for GitHub login:

1. Let active XAR tasks finish, then close XAR.
2. Download **XAR-Upgrader.exe** above and run it once.
3. It finds your existing Desktop XAR.exe, downloads the signed update, verifies
   it, backs up the old executable, and opens the updated app. Chats and settings
   stay in the existing local data folder.

For an app saved elsewhere, drag the existing XAR.exe onto XAR-Upgrader.exe, or
run `XAR-Upgrader.exe --target "C:\path\to\XAR.exe"`.

Older releases used GitHub CLI, which requires authentication before it requests
even a public repository. Making this repository public cannot change code
already installed on a PC. The one-time upgrader removes that dependency;
subsequent updates use direct public downloads automatically.

## Update verification and local data

XAR checks Ed25519-signed update metadata and the executable's exact SHA-256 and
size before installing it. The transition retains the original verification key
and rollback/startup checks. No shared GitHub token is shipped with the app.

Chats, provider credentials, local logs and the private signing key are not
uploaded to this release repository. XAR's local web service remains bound to
loopback. Downloading an update does not publish a user's workspace.

XAR 2.0.3 also adds Google Gemini Windows app and installed browser-app discovery,
with Gemini CLI shown separately in **Detected AIs**. Discovery reports observed
installation/process evidence; connecting an agent is a separate capability.
