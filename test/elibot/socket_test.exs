defmodule Elibot.SocketTest do
  use ExUnit.Case

  alias Elibot.Socket

  @socket_pid 123
  @token "1234"
  @url "https://slack.com/api/rtm.start?token=1234"

  defmodule MockWebSocket do
    def start_link("wss", module, args) do
      {:ok, 123}
    end

    def start_link(_, module, args) do
      {:error, "wrong arg for socket start link"}
    end
  end

  defmodule MockHttp do
    def get("https://slack.com/api/rtm.start?token=1234") do
      {:ok, %HTTPoison.Response{status_code: 200,
                                headers: [],
                                body: "{\"url\": \"wss\"}"}}
    end

    def get(url) do
      {:error, "wrong arg for http get: " <> url}
    end
  end

  defmodule MockEventServer do
  end

  test "start event server" do
    assert {:ok, @socket_pid} = Socket.start_link(@token,
      MockWebSocket,
      MockHttp,
      MockEventServer)
  end
end
