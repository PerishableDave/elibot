defmodule Elibot do
  use Application

  def start(_type, _args) do
    token = Application.get_env(:elibot, :token)
    if token == nil do
      raise("Set Slack API token in your config file.")
    end

    Elibot.Supervisor.start_link(token)
  end
end
