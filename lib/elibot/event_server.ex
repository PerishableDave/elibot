defmodule Elibot.EventServer do

  def start_link do
    GenEvent.start_link(name: __MODULE__)
  end

  def handle_event(conn, event) do
    GenEvent.notify(__MODULE__, {conn, event})
  end

  def add_handler(handler, args) do
    GenEvent.add_handler(__MODULE__, handler, args)
  end

  def remove_handler(handler, args) do
    GenEvent.remove_handler(__MODULE__, handler, args)
  end
end
