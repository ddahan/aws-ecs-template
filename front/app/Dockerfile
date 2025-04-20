# Build stage
FROM node:20-alpine AS build

WORKDIR /app

COPY . .

ARG NUXT_API_BASE
ENV NUXT_API_BASE=$NUXT_API_BASE

RUN npm install
RUN npm run build

# Serve stage
FROM nginx:alpine

COPY --from=build /app/.output/public /usr/share/nginx/html

COPY nginx.conf /etc/nginx/conf.d/default.conf