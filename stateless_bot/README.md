# MyBot (Stateless)

State? Not here!

A very small example bot not utilizing `crux_cache` to cache data and just directly consuming `crux_gateway`'s data.

## Installation

```
git clone https://github.com/SpaceEEC/crux_examples.git
cd crux_examples/stateless_bot
mix do deps.get, compile
```

## Run

```
# You need to configure your bot's token in config/config.exs first
iex -S mix
```