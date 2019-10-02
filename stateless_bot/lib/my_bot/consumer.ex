defmodule MyBot.Consumer do
  @moduledoc """
    The consumer for this bot.

    Will be started for all incoming events.

    Started and supervised by `MyBot.ConsumerSupervisor`.
  """

  def child_spec(_arg) do
    %{
      id: __MODULE__,
      start: {__MODULE__, :start_link, []},
      # :temporary for no restart at all
      # :transient for restarts on abnormal exits (up to some limit)
      # :permanent is invalid here, as this is a non-permanent consumer
      restart: :temporary
    }
  end

  # "data" will be {event_type :: atom(), data :: map(), shard_id :: non_neg_integer()}
  def start_link(data) do
    # Convert it to a list to call handle_event/3
    Task.start_link(__MODULE__, :handle_event, Tuple.to_list(data))
  end

  def handle_event(type, data, shard_id)

  # "data" will be a Message Object https://discordapp.com/developers/docs/resources/channel#message-object here
  def handle_event(
        :MESSAGE_CREATE,
        %{content: "!ping", channel_id: channel_id, author: %{id: user_id}},
        shard_id
      ) do
    MyBot.Rest.create_message!(channel_id,
      content: "Pong, <@#{user_id}>! Your request was received on shard #{shard_id}."
    )
  end

  # Fallback for everything unexpected or what we don't want to handle.
  # You never know what Discord might end up sending you.
  def handle_event(_type, _data, _shard_id) do
    nil
  end
end
