defmodule MyBot.Application do
  @moduledoc """
    The main entry point for this bot.

    First starts `MyBot.Rest` and then `MyBot.Supervisor` under its own supervisor.

    A second supervisor is necessary here because `Crux.Gateway` requries the gateway url
    when configured and we need to start out `MyBot.Rest` module to fetch it.

    (Having to do that will hopefully get "fixed" eventually.)
  """

  use Application

  def start(_type, _args) do
    token =
      Application.get_env(:my_bot, :token) ||
        raise "You need to configure your bot token in the configuration! (config/config.exs)"

    children = [
      {MyBot.Rest, token: token},
      {MyBot.Supervisor, token}
    ]

    opts = [strategy: :one_for_one, name: __MODULE__]
    Supervisor.start_link(children, opts)
  end
end

defmodule MyBot.Supervisor do
  @moduledoc """
    The second supervisor for this bot.

    Supervises a `Crux.Gateway` process and the `MyBot.ConsumerSupervisor` process.
  """

  use Supervisor

  def start_link(token) do
    # Get the gateway url, or fail starting this supervisor early
    with {:ok, %{"url" => url, "shards" => shard_count}} <- MyBot.Rest.gateway_bot() do
      Supervisor.start_link(__MODULE__, {token, url, shard_count}, name: __MODULE__)
    end
  end

  def init({token, url, shard_count}) do
    gateway_opts = %{
      token: token,
      url: url,
      shard_count: shard_count
    }

    children = [
      # Give the gateway process a nice name
      {Crux.Gateway, {gateway_opts, name: MyBot.Gateway}},
      MyBot.ConsumerSupervisor
    ]

    opts = [strategy: :one_for_one]
    Supervisor.init(children, opts)
  end
end
