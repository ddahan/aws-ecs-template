<template>
    <div>
      <h1>Nuxt 3 SPA with Docker + Nginx</h1>
      <p>Message from API: {{ message }}</p>
    </div>
  </template>
  
  <script setup lang="ts">
  // omitting credentials only for CORS to work with '*'
  const { data: message } = await useFetch(`${useRuntimeConfig().public.apiBase}/api/hello`, { credentials: 'omit' })
  </script>