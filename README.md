# MT Skills Tracker v10

PI Field Service · MT Vietnam skills assessment app (built `dist`).

Open `index.html` via a static host, or serve this folder locally.

Admin PIN is set in **Settings**. Use **View only / Admin** in the header to sign in before creating sessions or saving scores.

## Firebase Rules (cross-device / incognito login)

This static app has no Firebase Auth. Realtime Database must allow public read/write for sync to work.

In Firebase Console → Realtime Database → Rules, publish:

```json
{
  "rules": {
    ".read": true,
    ".write": true
  }
}
```

Or deploy `database.rules.json` from this repo. If Rules block access, the header shows **Cloud bị khóa Rules**. Temporary workaround: Backup JSON on the main PC, then Restore JSON on the other browser before login.
