FROM elixir:1.5

ENV DEBIAN_FRONTEND=noninteractive

ADD . /opt/app/

RUN mix local.hex --force && \
    mix local.rebar --force

WORKDIR /opt/app

RUN rm -rf _build deps

ENV PORT=8000 MIX_ENV=prod REPLACE_OS_VARS=true SHELL=/bin/bash

RUN mix deps.get
RUN mix deps.compile

RUN mix release --env=prod

EXPOSE 8000
