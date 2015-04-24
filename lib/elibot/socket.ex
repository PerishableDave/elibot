defmodule Elibot.Socket do
  @behaviour :websocket_client_handler

  @start_url "https://slack.com/api/rtm.start?token="

  def start_link(token,
                 socket \\ :websocket_client,
                 http \\ HTTPoison,
                 event_server \\ Elibot.EventServer) do
    http.get(@start_url <> token)
      |> process_start_url
      |> start_socket(socket, event_server)
  end

  # :websocket_client_handler

  def init([event_server], _conn) do
    {:ok, event_server}
  end

  def websocket_handle({:text, message}, event_server) do
    message
      |> decode_message
      |> event_server.handle_event
    {:ok, event_server}
  end

  def websocket_handle({:ping, data}, _conn, event_server) do
    {:reply, {:pong, data}, event_server}
  end

  def websocket_info(_, _, state) do
    {:ok, state}
  end

  def websocket_terminate(_, _, _), do: :ok

  # Helper methods

  defp decode_message(message) do
    Poison.decode!(message, keys: :atoms!)
  end

  defp process_start_url({:ok, response}) do
    url = Poison.decode!(response.body)
      |> Dict.get("url")
    {:ok, url}
  end

  defp process_start_url(error), do: error

  defp start_socket({:ok, url}, socket, event_server) do
    socket.start_link(url, __MODULE__, [event_server])
  end

  defp start_socket(error, _socket, _event_server), do: error
end
