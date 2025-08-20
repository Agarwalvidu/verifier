# ---------------------------
# Stage 1: Build the Next.js app
# ---------------------------
FROM node:18-alpine AS builder

# Set working directory
WORKDIR /app

# Install dependencies (only package.json + lock first for caching)
COPY package.json package-lock.json ./
RUN npm ci

# Copy rest of the application
COPY . .

# Build the Next.js app
RUN npm run build

# ---------------------------
# Stage 2: Production image
# ---------------------------
FROM node:18-alpine AS runner

WORKDIR /app

# Set NODE_ENV to production
ENV NODE_ENV=production

# Copy only necessary files from builder
COPY --from=builder /app/package.json ./
COPY --from=builder /app/package-lock.json ./
COPY --from=builder /app/.next ./.next
COPY --from=builder /app/public ./public
COPY --from=builder /app/node_modules ./node_modules

# Expose Next.js default port
EXPOSE 3000

# Start the app
CMD ["npm", "run", "start", "--", "-H", "0.0.0.0"]


