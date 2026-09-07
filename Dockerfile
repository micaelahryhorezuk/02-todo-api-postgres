# Instala únicamente las dependencias necesarias en producción.
FROM node:20-alpine AS dependencies

WORKDIR /app

COPY package*.json ./

RUN npm install --omit=dev

# Imagen final de ejecución, sin dependencias de desarrollo ni archivos de build.
FROM node:20-alpine AS runtime

WORKDIR /app

ENV NODE_ENV=production

COPY --from=dependencies /app/node_modules ./node_modules
COPY package*.json ./
COPY server.js db.js ./

USER node

EXPOSE 3001

CMD ["node", "server.js"]
