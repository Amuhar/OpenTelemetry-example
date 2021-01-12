FROM elixir:1.10.4-alpine

ADD . /app
WORKDIR /app

RUN mix local.hex --force
RUN mix local.rebar --force

RUN mix deps.get
RUN mix compile