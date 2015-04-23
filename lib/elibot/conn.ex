defmodule Elibot.Conn do
  def send_message(conn, channel, message) do
    payload = Poison.encode!(%{type: "message", text: message, channel: channel})
    :websocket.send({:text, payload}, conn)
  end
end
