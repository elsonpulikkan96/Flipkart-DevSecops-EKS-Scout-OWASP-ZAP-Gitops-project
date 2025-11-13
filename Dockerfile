# ---------- Build Stage ----------
FROM node:18-bullseye AS build

# Set working directory
WORKDIR /app

# Make react-scripts behave for CI and avoid sourcemaps
ENV CI=true
ENV GENERATE_SOURCEMAP=false

# Copy dependency files first for better caching
COPY package*.json ./

# Use npm ci for deterministic install (faster & safer in CI)
RUN npm ci --silent

# Copy rest of the code
COPY . .

# Build optimized production build
RUN npm run build

# ---------- Production Stage ----------
FROM nginx:stable-alpine

# Remove default nginx content and copy build output to nginx html directory
RUN rm -rf /usr/share/nginx/html/*
COPY --from=build /app/build /usr/share/nginx/html

# Expose port 80
EXPOSE 80

# Start nginx
CMD ["nginx", "-g", "daemon off;"]
