export default defineNuxtConfig({
  ssr: false,
  nitro: {
    preset: 'static'
  },
  runtimeConfig: {
    public: {
      apiBase: process.env.NUXT_API_BASE || 'http://localhost:8000', // will work for local because NUXT_API_BASE is not defined
    },
  },
})