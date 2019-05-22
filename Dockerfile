FROM elixir:1.8.1-alpine as builder

ENV MIX_ENV prod

RUN apk add --no-cache git build-base

RUN mix local.hex --force
RUN mix local.rebar --force

WORKDIR /app

COPY . /app

RUN mix deps.get
RUN mix deps.compile

ARG SECRET_KEY_BASE

RUN SECRET_KEY_BASE=$SECRET_KEY_BASE mix compile
RUN mix release

# Release image
FROM elixir:1.8.1-alpine

RUN apk add --no-cache bash

WORKDIR /app

COPY --from=builder /app/_build/prod/rel/sanbase .

ENV REPLACE_OS_VARS=true

CMD bin/sanbase foreground