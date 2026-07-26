FROM node:22-alpine
RUN apk add --no-cache openssl

WORKDIR /app

# Install all dependencies (including devDependencies required for react-router build)
COPY package.json package-lock.json* ./
RUN npm ci --engine-strict=false

# Copy application files
COPY . .

# Generate Prisma Client & Build React Router app
RUN npx prisma generate
RUN npm run build

# Remove devDependencies to optimize image size
RUN npm prune --omit=dev --engine-strict=false && npm cache clean --force

ENV NODE_ENV=production
ENV PORT=3000
ENV HOST=0.0.0.0

EXPOSE 3000

CMD ["npm", "run", "docker-start"]
