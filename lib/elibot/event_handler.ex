defmodule Elibot.EventHandler do
  use GenEvent

  def init(module) do
    {:ok, module}
  end

  def handle_event(event, module) do
    module.handle_event(event)
  end
end
