defmodule MySupervisor do
  use Supervisor

  def start_link(opts) do
      Supervisor.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
      children = [
          {Task.Supervisor, name: Router},
      ]

      Supervisor.init(children, strategy: :one_for_all)
  end
end
