defmodule Elibot.EventServerTest do
  use ExUnit.Case, async: true

  alias Elibot.EventServer

  defmodule MockHandler do
    use GenEvent

    def init(pid) do
      {:ok, pid}
    end

    def handle_event(event, pid) do
      send pid, event
      {:ok, pid}
    end
  end

  setup do
    EventServer.start_link()
    :ok
  end

  test "add handler" do
    EventServer.add_handler(MockHandler, self)
    assert [MockHandler] == GenEvent.which_handlers(EventServer)
  end

  test "remove handler" do
    EventServer.add_handler(MockHandler, self)
    EventServer.remove_handler(MockHandler, [])
    assert [] == GenEvent.which_handlers(EventServer)
  end

  test "event is handled" do
    EventServer.add_handler(MockHandler, self)
    EventServer.handle_event(:conn, :event)
    assert_receive {:conn, :event}
  end
end
