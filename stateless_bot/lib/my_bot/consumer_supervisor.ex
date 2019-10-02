defmodule MyBot.ConsumerSupervisor do
  @moduledoc """
    A `ConsumerSupervisor` (https://hexdocs.pm/gen_stage/ConsumerSupervisor.html) to spawn tasks handling incoming
    events from Discord received by `crux_gateway`.

    Started and supervised by `MyBot.Supervisor`.
  """

  use ConsumerSupervisor

  def start_link(arg) do
    ConsumerSupervisor.start_link(__MODULE__, arg, name: __MODULE__)
  end

  def init(_arg) do
    children = [
      MyBot.Consumer
    ]

    # Get all gateway producer pids
    gateway_producers = Crux.Gateway.Connection.Producer.producers(MyBot.Gateway) |> Map.values()

    opts = [strategy: :one_for_one, subscribe_to: gateway_producers]

    ConsumerSupervisor.init(children, opts)
  end
end
