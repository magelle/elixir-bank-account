defmodule MySupervisor do
  use Supervisor

  def start_link(opts) do
      Supervisor.start_link(__MODULE__, :ok, opts)
  end

  def init(:ok) do
      children = [
          {DynamicSupervisor, name: AccountSupervisor, strategy: :one_for_one},
          {Task.Supervisor, name: Router},
          {PartitionedBank, name: PartitionedBank},
      ]

      Supervisor.init(children, strategy: :one_for_all)
  end
end
