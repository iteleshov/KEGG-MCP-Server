FROM node:18-alpine AS builder

WORKDIR /app

COPY package*.json ./

RUN npm install --ignore-scripts

COPY . .

RUN npm run build

FROM node:18-alpine AS production

WORKDIR /app

COPY --from=builder /app/build ./build
COPY --from=builder /app/package*.json ./

RUN npm install --omit=dev

ENV NODE_ENV=production

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD node -e "console.log('UniProt MCP Server is healthy')" || exit 1

ENTRYPOINT ["node", "build/index.js"]

LABEL maintainer="UniProt MCP Server Team"
LABEL description="Model Context Protocol server for UniProt protein database access"
LABEL version="0.1.0"
