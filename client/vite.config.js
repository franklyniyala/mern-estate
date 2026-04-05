import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react-swc';

// https://vitejs.dev/config/
export default defineConfig({
  plugins: [react()],
  server: {
    host: '0.0.0.0',
    ports: 5173,
    proxy: {
      '/api': {
        target: 'http://api:3000',
        secure: false,
      },
    },
  },

  plugins: [react()],
});
