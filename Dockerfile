# syntax=docker/dockerfile:1

# to run debug mode
# sudo docker build --no-cache -t playgroundjs:latest --progress=plain . &> dockerBuild.log
# build.log file will be generated

# default image name: playgroundjs:latest

ARG devPort=2020
ARG prodPort=1050

FROM node:20-alpine as setup

WORKDIR /playgroundjs
# on setup environments always specify the deps version to avoid break changes
RUN npm install --global pnpm@9.1.4

# To run development
# sudo docker build --no-cache -t playgroundjs:latest --target development .
# sudo docker run type=bind,src=.,target=/playgroundjs -p 127.0.0.1:2020:2020 playgroundjs:latest
FROM setup as development

EXPOSE $devPort

ENV PORT=$devPort
# need to install dependencies in the directory cuz .dockerignore
# this directory will have only dependencies, to run that you need to bind mount on docker run
RUN --mount=type=bind,source=package.json,target=./package.json \
  --mount=type=bind,source=pnpm-lock.yaml,target=./pnpm-lock.yaml \
  pnpm install

# how to add args in CMD command?
CMD pnpm dev -p 2020

FROM setup as build
COPY . .

RUN pnpm install
RUN pnpm build

# To run prod
# sudo docker build --no-cache -t playgroundjs:latest .
# sudo docker run -p 127.0.0.1:1050:1050 playgroundjs:latest
FROM node:20-alpine as production

WORKDIR /playgroundjs

COPY --from=build /playgroundjs/.next/standalone ./
COPY --from=build /playgroundjs/.next/static ./.next/static

ENV PORT=1050
EXPOSE 1050

CMD node server.js
