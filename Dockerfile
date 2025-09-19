# Stage 1: build the application
FROM node:20-alpine AS builder

# Create app directory
WORKDIR /app

# Copy package definition files first for better caching
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the source code
COPY . .

# Build the application for production (static files will be under /app/dist)
RUN npm run build

# Stage 2: serve the built files in a lightweight container
FROM node:20-alpine AS runner

WORKDIR /app

# Install a simple static file server
RUN npm install -g serve

# Copy built assets from the previous stage
COPY --from=builder /app/dist ./dist

# Expose port (Coolify will map this automatically)
EXPOSE 3000

# Start the app with "serve"
CMD ["serve", "-s", "dist", "-l", "3000"]