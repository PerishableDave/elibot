defmodule Elibot.Socket do
  use GenServer

  @start_url "https://slack.com/api/rtm.start?token="

  def start_link(token) do
    GenServer.start_link(__MODULE__, token, name: __MODULE__)
  end

  def init(token, socket \\ :websocket_client, http \\ HTTPoison) do
    http.get(@start_url <> token)
      |> process_start_url
      |> start_socket(socket)
  end

  def websocket_handle({:text, message}, conn, state) do
    Elibot.EventServer.handle_event(conn, decode(message))
    {:ok, state}
  end

  def decode(message) do
    Poison.decode!(message, keys: :atoms!)
  end

  defp process_start_url({:ok, response}) do
    url = Poison.decode!(response.body)
      |> Dict.get("url")
    {:ok, url}
  end

  defp process_start_url(error), do: error

  defp start_socket({:ok, url}, socket) do
    socket.start_link(url, __MODULE__, [])
  end

  defp start_socket(error), do: error
end
