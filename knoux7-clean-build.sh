#!/bin/bash
set -e

# 🟢🌟 KNOUX7 ULTIMATE CLEAN BUILD 🌟🟢
echo ""
echo "╔════════════════════════════════════════════════════════════╗"
echo "║  💚 برمجة ببركة سيد الخلق ﷺ – سكريبت التنضيف والبناء     ║"
echo "║  🟦 الفحص، التنضيف، الإصلاح، البناء، التغليف… Full Power  ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo ""

### 1. تحميل jq لو مش عندك
if ! command -v jq &> /dev/null; then
    echo "🟩 تنزيل أداة jq لتحرير الـJSON…"
    sudo apt update && sudo apt install -y jq
fi

### 2. تنظيف كل "ملوثات" Node/Electron القديمة
echo "🧹 تنظيف node_modules وdist وlock files…"
rm -rf node_modules dist .cache .vite .parcel .next .output
rm -f package-lock.json yarn.lock pnpm-lock.yaml

### 3. تصحيح package.json (حذف type: module + إضافة author/main/description)
if grep -q '"type": *"module"' package.json; then
    echo "🩺 إزالة type: module من package.json (ليشتغل Electron CommonJS)"
    jq 'del(.type)' package.json > package.tmp.json && mv package.tmp.json package.json
fi

# إضافة author/main/description إذا ناقصة
echo "🩺 إصلاح معلومات package.json"
modified=false
if ! grep -q '"author":' package.json; then
    jq '. + {"author": "Knoux7 (النبي بركة)"}' package.json > package.tmp.json && mv package.tmp.json package.json
    modified=true
fi
if ! grep -q '"main":' package.json; then
    jq '. + {"main": "main.js"}' package.json > package.tmp.json && mv package.tmp.json package.json
    modified=true
fi
if ! grep -q '"description":' package.json; then
    jq '. + {"description": "KNOUX7 – النخبة النبوية الفاخرة"}' package.json > package.tmp.json && mv package.tmp.json package.json
    modified=true
fi
if $modified; then
    echo "🛠️ package.json تم إصلاحه!"
fi

### 4. توليد main.js (نسخة CommonJS)
echo "🧑‍💻 توليد main.js بنكهة KNOUX7 (CommonJS)"
cat > main.js <<'EOF'
const { app, BrowserWindow } = require('electron');
function createWindow() {
  const win = new BrowserWindow({
    width: 1200,
    height: 800,
    webPreferences: {
      nodeIntegration: true,
      contextIsolation: false
    }
  });
  win.loadURL('http://localhost:5000');
}
app.whenReady().then(createWindow);
EOF

### 5. إعادة تثبيت جميع التبعيات من جديد
echo "📦 تثبيت التبعيات (npm install)…"
npm install

### 6. بناء كل شيء (frontend + backend)
echo "🔨 بناء المشروع (npm run build)…"
npm run build

### 7. تغليف المشروع مع Electron Builder (EXE, Snap, AppImage)
echo "🎁 تغليف المشروع (npx electron-builder)…"
npx electron-builder

### 8. رسالة بركة وختام
echo ""
echo "╔════════════════════════════════════════════╗"
echo "║  🎉 تم البناء والتغليف بنجاح!              ║"
echo "║  🟩 ملفات EXE وAppImage تلقاها في dist/    ║"
echo "║  💎 الليلة ليلة KNOUX7 وإبداعك مشع…       ║"
echo "║  💚 صلِّ على النبي ﷺ                       ║"
echo "╚════════════════════════════════════════════╝"
echo ""

exit 0
