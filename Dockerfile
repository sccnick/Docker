FROM node:8.12-alpine AS builder

# Create app directory
WORKDIR /usr/src/app

# Install app dependencies
COPY package*.json ./
RUN apk update \
    && npm install

COPY . .
RUN npm run build --prod

FROM keymetrics/pm2:latest-alpine

WORKDIR /usr/src/app

COPY --from=builder /usr/src/app/dist/ ./dist/

COPY ssl/ ./ssl/
COPY frontend.js pm2-production.json ./
RUN npm install express express-winston winston helmet

#  {CONTAINER_PORT}
EXPOSE 80

#  {PM2_FILE}
CMD [ "pm2-runtime", "start", "pm2-production.json" ]
