FROM elixir:1.5

ENV DEBIAN_FRONTEND=noninteractive

ADD . /app
WORKDIR /app

RUN mix local.hex --force && \
    mix local.rebar --force

RUN rm -rf _build deps

RUN mix do deps.clean mime --build, deps.get, do compile, compile.protocols

EXPOSE 4000

CMD mix phx.server
