# Tự động backup code từ GitHub (Mac mini)

Không cần gõ terminal mỗi lần. Cài **một lần** bằng double-click:

1. Mở folder repo (sau khi đã có trên máy), vào `tools/mac-auto-sync/`
2. Double-click `Cai-dat-tu-dong-backup.command`
3. Nếu macOS hỏi quyền, chọn **Open**

Sau đó mỗi giờ (và lúc đăng nhập) máy sẽ `git fetch` + `reset --hard` nhánh `main` vào:

`~/Documents/MTVN_FT_PI`

Log: `~/Library/Logs/MTVN_FT_PI/auto-sync.log`

Gỡ: double-click `Go-tu-dong-backup.command`.

> Lưu ý: script **ghi đè** thay đổi local trong repo đó để luôn giống GitHub. Chỉ dùng folder này làm bản sao backup/code, không sửa trực tiếp trong đó.
