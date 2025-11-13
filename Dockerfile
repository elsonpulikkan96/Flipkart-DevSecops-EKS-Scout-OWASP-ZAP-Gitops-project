# ---------- Build stage ----------
FROM node:18-bullseye AS builder

WORKDIR /app

ENV NODE_ENV=production
ENV GENERATE_SOURCEMAP=false

# Install only build dependencies via npm ci
COPY package*.json ./
RUN npm ci --silent

# Copy app and build
COPY . .
RUN npm run build

# ---------- Production stage ----------
FROM nginx:stable-alpine AS runtime

# Install curl so HEALTHCHECK and simple debugging work inside container
RUN apk add --no-cache curl

# Remove default nginx content and add our build
RUN rm -rf /usr/share/nginx/html/*
COPY --from=builder /app/build /usr/share/nginx/html

# Lightweight healthcheck using curl (fast timeout)
HEALTHCHECK --interval=30s --timeout=3s --start-period=10s --retries=3 \
  CMD curl -fsS --max-time 2 http://localhost/ || exit 1

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
