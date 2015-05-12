defmodule Elibot.ConnTest do
  use ExUnit.Case

  alias Elibot.Conn

  defmodule MockWebSocket do
    def send({:text, "{\"type\":\"message\",\"text\":\"message\",\"channel\":123}"}, conn) do
      :ok
    end
  end

  test "send message" do
    conn = :websocket_req.new(:wss, "test", 80 ,"path", nil, nil, nil, nil)
    assert :ok = Conn.send_message(conn, 123, "message", MockWebSocket)
  end
end
