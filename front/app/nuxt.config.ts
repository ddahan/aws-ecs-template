export default defineNuxtConfig({
  ssr: false,
  runtimeConfig: {
    public: {
      apiBase: process.env.NUXT_API_BASE || 'http://localhost:8000',
    },
  },
})