import { defineConfig, loadEnv } from 'vite'
import vue from '@vitejs/plugin-vue'

export default defineConfig(({ mode }) => {
  // Carrega variáveis com prefixo VITE_*
  const env = loadEnv(mode, process.cwd(), '')

  return {
    plugins: [vue()],
    // Durante desenvolvimento usamos proxy para evitar CORS
    server: {
      proxy: {
        '/api': {
          target: env.API_PROXY_TARGET || 'https://localhost:32769',
          changeOrigin: true,
          secure: false,
          rewrite: (path) => path.replace(/^\/api/, '')
        }
      }
    },
    build: {
      outDir: 'dist'
    }
  }
})