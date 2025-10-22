FROM node:20-slim

WORKDIR /app

COPY package*.json ./

RUN npm install --ignore-scripts

COPY . .

RUN npm run build

RUN npm prune --production

EXPOSE 3000

ENTRYPOINT ["node", "build/index.js"]
