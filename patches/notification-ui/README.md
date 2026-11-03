# XAR 2.0.5 notification patch

Replaces the oversized desktop recovery notice with a compact card. This is a UI patch for an existing XAR 2.0.5 installation, not a signed executable release. The automatic updater does not install it.

- Compact, opaque dark card at the upper right.
- Clear title and short description.
- Expandable original recovery information.
- Auto Help shortcut and the original dismiss handler.
- Viewport bounds and reduced-motion support.

## Install

Download this folder's four files together. Close XAR after any active work finishes. In PowerShell, run:

```powershell
& .\Apply-NotificationUpdate.ps1
```

The script targets the standard XAR 2.0.5 install, backs up affected UI files, and can be run again safely. Reopen XAR afterward. No credentials, chats, or workspace files are included or modified.

For a custom installation:

```powershell
& .\Apply-NotificationUpdate.ps1 -PublicDirectory 'C:\path\to\XAR\app\public'
```

For manual integration, copy `notification-ui.js` into `public`, import `./notification-ui.js` from `app.js`, and append `notification-ui.css` to `style.css`.

## Restore

The script prints its `.notification-backup-*` directory. With XAR closed, restore `app.js` and `style.css` from that directory to `public`. Without the import, the new module is inactive.

JavaScript syntax, HTTP delivery, live desktop appearance, recovery-details expansion, dismissal, and persistence after restarting XAR were checked. A future XAR version may replace these local files and require a compatible patch.
