defmodule Elibot.Socket do
  use GenServer

  def start_link(url) do
    GenServer.start_link(__MODULE__, url, name: __MODULE__)
  end

  def init(url) do
    :websocket_client.start_link(url, __MODULE__, [])
  end

  def websocket_handle({:text, message}, conn, state) do
    decode(message) |> Elibot.EventServer.handle_message

    {:ok, state}
  end

  def decode(message) do
    Poison.decode!(message, keys: :atoms!)
  end
end
