defmodule Elibot.Supervisor do
  use Supervisor

  def start_link do
    Supervisor.start_link(__MODULE__, [])
  end

  def init(token) do
    children = [
      worker(Elibot.EventServer, []),
      worker(Elibot.Socket, [token])
    ]

    supervise(children, strategy: :one_for_one)
  end
end
