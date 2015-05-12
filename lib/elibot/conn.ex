defmodule Elibot.Conn do
  def send_message(conn, channel, message, socket \\ :websocket_client) do
    payload = Poison.encode!(%{type: "message", text: message, channel: channel})
    socket.send({:text, payload}, conn)
  end
end
