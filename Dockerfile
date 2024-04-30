# Use an official Elixir runtime as the base image
FROM elixir:latest AS builder

# Set environment variables for running in production
ENV MIX_ENV=prod \
    PORT=4369 \
    REPLACE_OS_VARS=true \
    SHELL=/bin/bash

# Set the working directory in the container
WORKDIR /app

# Install hex package manager and rebar for Elixir
RUN mix local.hex --force && \
    mix local.rebar --force

# Install the necessary dependencies
COPY mix.exs mix.lock ./
RUN mix deps.get --only prod && \
    mix deps.compile

# Copy the application code
COPY . .

# Compile the Elixir application
RUN mix compile

# Build the release
RUN mix release

FROM elixir:slim AS final

WORKDIR /app

# Copy the _build directory from the build stage
COPY --from=builder /app/_build ./_build

# Expose the application port
EXPOSE $PORT

# Set the entry point for the container
ENTRYPOINT ["_build/prod/rel/elixir_delhi_bot/bin/elixir_delhi_bot"]
CMD ["start"]