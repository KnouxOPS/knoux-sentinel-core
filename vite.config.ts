import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';
import path from 'path'; // <- ضيف السطر ده عشان نستخدم path

export default defineConfig({
  plugins: [react()],
  // لازم هنا نحدد جذر تطبيق الـ frontend داخل مجلد الـ 'client'
  root: 'client', // <- تأكد أن جذر Vite هو مجلد client

  resolve: {
    alias: {
      // هنا بنقول لـ Vite إن '@' = 'client/src'
      '@': path.resolve(__dirname, './client/src'), // <- السطر ده هو أهم حل لمشكلة الـ @
    },
  },
  build: {
    // لازم بناء الواجهة يكون داخل dist/public
    outDir: './dist/public', // <- تأكد أن الواجهة تبني هنا
    emptyOutDir: true,
  },
  // حل مشكلة 'defineConfig' is undefined في السيرفر
  optimizeDeps: {
    exclude: ['vite']
  }
});