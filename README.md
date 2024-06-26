Docker Netlify CLI
==================

> Docker image to use [Netlify CLI](https://www.npmjs.com/package/netlify-cli) without installing it

| CD / CI   | Status |
| --------- | ------ |
| Semaphore CI | [![Build Status](https://sineverba.semaphoreci.com/badges/docker-netlify-cli/branches/master.svg?style=shields)](https://sineverba.semaphoreci.com/projects/docker-netlify-cli) |


## Usage

`$ docker run --rm -it sineverba/netlify-cli:1.0.1 -v [YOUR_VOLUME]:app/ netlify [COMMAND]`


## Usage in .bashrc

`alias netlify='docker run -it -v ${PWD}:/app --entrypoint netlify --rm sineverba/netlify-cli:1.0.1'`

## Github / image tags and versions

| Github / Docker Image tag | Node Version | NPM Version | Netlify version | Architecture |
| ------------------------- | ------------ | ----------- | --------------- | ------------ |
| 1.0.1 | 20.12.0 | 10.5.0 | 17.15.1 | linux/amd64, linux/arm64/v8 |