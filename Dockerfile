FROM node:18 as build

WORKDIR /app

COPY package*.json ./

RUN npm install

COPY . .

RUN npm run build:prod

RUN npm prune --production

RUN npm cache clean --force

FROM nginx

COPY --from=build /app/dist /usr/share/nginx/html/

ENV BASE_URL=aichat-admin:8080

COPY docker/nginx.conf /etc/nginx/nginx.conf
COPY docker/start.sh /start.sh

RUN chmod +x /start.sh

EXPOSE 80

CMD ["bash", "/start.sh"]
