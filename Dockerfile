ARG NODE_VERSION=20.12.0
FROM node:$NODE_VERSION-alpine3.19
# Set versions from Make, otherwise use default
## NPM
ARG NPM_VERSION=latest
ENV NPM_VERSION $NPM_VERSION
## NETLIFY
ARG NETLIFY_CLI_VERSION=latest
ENV NETLIFY_CLI_VERSION $NETLIFY_CLI_VERSION
# Update and upgrade
RUN apk update && \
    apk upgrade --available --no-cache && \
    rm -rf /var/cache/apk/*
# Install
RUN npm install -g npm@$NPM_VERSION && npm install -g netlify-cli@$NETLIFY_CLI_VERSION
# Set workdir
WORKDIR /app
