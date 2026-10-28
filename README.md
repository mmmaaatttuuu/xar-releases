# XAR private releases

This private repository distributes signed XAR Windows update artifacts.

Each stable release contains `XAR.exe` and signed `update.json`. The application checks this repository on startup using the signed-in user's GitHub access. No reusable access token or private signing key is embedded in the executable.

This repository is intentionally private. Do not publish it or upload personal workspace data, chats, credentials, signing keys, or local logs.

The first version supporting private startup updates is 1.2.0. Existing installations need that version installed once. Future newer signed releases can update the same executable automatically.
