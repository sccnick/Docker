FROM node:8.12-alpine AS builder

# Create app directory
WORKDIR /usr/src/app

# Install app dependencies
COPY package*.json ./
RUN apk update \
    && apk add git \
    && npm install

COPY . .
RUN npm run build

FROM keymetrics/pm2:latest-alpine

WORKDIR /usr/src/app

COPY --from=builder /usr/src/app/dist /app/dist

COPY pm2*.json ./

EXPOSE ${CONTAINER_PORT}

CMD [ "pm2-runtime", "start", "${PM2_FILE}" ]