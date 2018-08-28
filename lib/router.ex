defmodule Router do

  def printNodeName(nodeName) do
    Task.Supervisor.async({Router, nodeName}, Router, :printNode, [])
    |> Task.await()
  end

  def printNode() do
    IO.puts node()
    node()
  end

end
