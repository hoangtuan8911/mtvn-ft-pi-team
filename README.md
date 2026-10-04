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

### Upload local Backup JSON to cloud

Admin header button **⬆️ Đẩy file lên Cloud** reads a previously downloaded Backup JSON and writes it to Firebase (`backups/*` + live paths). Requires open Realtime Database Rules. Use this to re-seed cloud from a file kept on your PC (e.g. after data loss).

### Backup trước khi Import Excel

Pending Job / Sharepoint Job **Import Excel** và **Xóa data** gọi `bkRequireCloud` trước khi đổi data. Nếu ghi cloud thất bại → thao tác bị hủy và hiện lỗi. Backup JSON thủ công cũng báo **⛔ LỖI** khi file tải được nhưng cloud fail.
