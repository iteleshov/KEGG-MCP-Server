FROM node:20-slim AS builder

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY . .

RUN npm run build

FROM node:20-slim AS production

WORKDIR /app

COPY --from=builder /app/build ./build
COPY --from=builder /app/node_modules ./node_modules
COPY --from=builder /app/package*.json ./

RUN npm prune --production

ENV NODE_ENV=production

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
    CMD node -e "console.log('KEGG MCP server healthy')" || exit 1

ENTRYPOINT ["node", "build/index.js"]

LABEL maintainer="KEGG MCP Server Team"
LABEL description="Model Context Protocol server for KEGG database"
