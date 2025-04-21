<template>
    <div>
      <h1>Nuxt 3 SPA (static files, no ssr) calling a fastAPI endpoint</h1>
      <p>Message from API: {{ message }}</p>
    </div>
  </template>
  
  <script setup lang="ts">
  const { data: message } = await useFetch(`${useRuntimeConfig().public.apiBase}/api/hello`)
  </script>