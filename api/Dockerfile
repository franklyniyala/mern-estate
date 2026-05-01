FROM node:20-alpine AS builder

WORKDIR /app

COPY package*.json ./

RUN npm ci

COPY . .

FROM node:20-alpine 

WORKDIR /app

COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app . 

RUN npm prune --omit=dev

EXPOSE 5000

CMD ["node", "index.js"]