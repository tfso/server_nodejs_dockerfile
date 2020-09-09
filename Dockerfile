FROM mhart/alpine-node:14.8

#Install packages
RUN apk update \
	&& apk add bash gcc g++ make python git openssh && rm -rf /var/cache/apk/*

RUN addgroup -S node && adduser -S node -G node

RUN chown -R node:node /usr/lib/node_modules

USER node

RUN npm install -g node-gyp
RUN npm install -g npm-start

WORKDIR /docker

COPY --chown=node:node startup.sh .

# give all execution rights
RUN chmod a+x startup.sh

RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/community >> /etc/apk/repositories
RUN echo http://dl-cdn.alpinelinux.org/alpine/edge/main >> /etc/apk/repositories
RUN apk add --no-cache w3m p7zip jq

WORKDIR /docker/src

ENTRYPOINT ["bash","/docker/startup.sh"]
