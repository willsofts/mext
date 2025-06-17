FROM node:20.18.0

ARG NPM_TOKEN
ENV NODE_ENV=production

RUN mkdir -p /usr/node/app
WORKDIR /usr/node/app

COPY package.json /usr/node/app/
COPY .npmrc /usr/node/app/

RUN npm install --omit=dev

COPY . /usr/node/app

EXPOSE 8080

CMD ["npm", "start"]
