FROM node:22

COPY root /

RUN set -eux; \
    cd /app; \
    npm install; \
    npm run build; \
    rm node_modules -rf; \
    npm install --omit=dev


WORKDIR /app

CMD ["node","/app/lib/run-tracker.js","/app/config.json"]
