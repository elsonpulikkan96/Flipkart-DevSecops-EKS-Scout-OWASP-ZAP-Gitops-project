# ---------- Build stage ----------
FROM node:18-bullseye AS builder

WORKDIR /app

# Build environment
ENV NODE_ENV=production
ENV GENERATE_SOURCEMAP=false

# Copy package files first to leverage layer caching
COPY package*.json ./

# Reproducible installs
RUN npm ci --silent

# Copy source and build
COPY . .
RUN npm run build

# ---------- Production / runtime stage ----------
FROM nginx:stable-alpine AS runtime

# Remove default nginx content and add our build artifacts
RUN rm -rf /usr/share/nginx/html/*
COPY --from=builder /app/build /usr/share/nginx/html

# Create a simple health endpoint and ensure permissions are OK for nginx
RUN echo "ok" > /usr/share/nginx/html/healthz \
 && chown -R nginx:nginx /usr/share/nginx/html \
 && chmod -R 644 /usr/share/nginx/html/*

# Small optional Docker healthcheck (kept for docker, not required by k8s)
HEALTHCHECK --interval=30s --timeout=3s --start-period=10s --retries=3 \
  CMD wget -qO- http://localhost/healthz >/dev/null || exit 1

EXPOSE 80

# Keep default nginx behavior (daemon off)
CMD ["nginx", "-g", "daemon off;"]
