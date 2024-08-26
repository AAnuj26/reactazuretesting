# Stage 1: Build Stage
FROM node:18-alpine AS builder

WORKDIR /app

# Copy package.json and package-lock.json
COPY package.json package-lock.json ./

# Install all dependencies (including dev dependencies)
RUN npm ci

# Copy the rest of the source code
COPY . .

# Build the application
RUN npm run build

# Clean up dev dependencies
RUN npm prune --omit=dev

# Stage 2: Final Stage
FROM nginx:alpine

# Remove the default nginx index.html
RUN rm /usr/share/nginx/html/index.html

# Copy the built files from the builder stage into the Nginx directory
COPY --from=builder /app/dist /usr/share/nginx/html

# Expose port 80 for the Nginx server
EXPOSE 80
