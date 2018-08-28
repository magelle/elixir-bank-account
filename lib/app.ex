defmodule App do
  use Application

  def start(_type, _args) do
    MySupervisor.start_link(name: Supervisor)
  end
end
