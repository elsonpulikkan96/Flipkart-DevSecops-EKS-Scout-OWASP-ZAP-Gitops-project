# ---------- Build stage ----------
FROM node:18-bullseye AS builder

# working dir
WORKDIR /app

# Keep build deterministic and avoid warnings-as-errors by NOT forcing CI=true.
# Avoid sourcemaps to speed up build and keep image smaller.
ENV NODE_ENV=production
ENV GENERATE_SOURCEMAP=false

# Copy package files first to leverage layer caching
COPY package*.json ./

# Use npm ci for reproducible installs in CI
RUN npm ci --silent

# Copy application source
COPY . .

# Build optimized production assets
RUN npm run build

# ---------- Production stage ----------
FROM nginx:stable-alpine AS runtime

# Remove default nginx content and add our build
RUN rm -rf /usr/share/nginx/html/*
COPY --from=builder /app/build /usr/share/nginx/html

# Optional: provide a small healthcheck
HEALTHCHECK --interval=30s --timeout=3s --start-period=10s --retries=3 \
  CMD wget -qO- http://localhost/ >/dev/null || exit 1

EXPOSE 80

# Run nginx in foreground
CMD ["nginx", "-g", "daemon off;"]
