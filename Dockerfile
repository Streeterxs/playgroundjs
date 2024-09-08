# syntax=docker/dockerfile:1

# to run debug mode
# sudo docker build --no-cache -t playgroundjs:latest --progress=plain . &> dockerBuild.log
# build.log file will be generated

# default image name: playgroundjs:latest

FROM node:20-alpine as setup

WORKDIR /playgroundjs

COPY . .

# on setup environments always specify the deps version to avoid break changes
RUN npm install --global pnpm@9.1.4

RUN pnpm install
RUN pnpm build

FROM node:20-alpine as starter

WORKDIR /playgroundjs

COPY --from=setup /playgroundjs/.next/standalone ./
COPY --from=setup /playgroundjs/.next/static ./.next/static

ENV PORT=355
EXPOSE 355

CMD node server.js
