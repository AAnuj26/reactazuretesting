# Stage 1: Build Stage
FROM node:18-alpine AS builder

WORKDIR /app

# Copy package.json and install dependencies
COPY package.json package-lock.json ./
RUN npm install

# Copy the rest of the files and build the app
COPY . .
RUN npm run build

# Stage 2: Final Stage
FROM node:18-alpine

WORKDIR /app

# Copy the built dist folder from the builder stage
COPY --from=builder /app/dist ./dist

EXPOSE 8080

CMD [ "npm", "run", "preview" ]
