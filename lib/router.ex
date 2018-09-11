defmodule Router do

  def route(partKey, mod, fun, args) do
    nodeName = getNode(partKey)
    Task.Supervisor.async({Router, nodeName}, mod, fun, args)
    |> Task.await()
  end

  def printNodeName(partKey) do
    nodeName = getNode(partKey)
    Task.Supervisor.async({Router, nodeName}, Router, :printNode, [])
    |> Task.await()
  end

  def printNode() do
    IO.puts node()
    node()
  end

  def getNode(partitionKey) do
    key = :binary.first(partitionKey)
    index = rem(key, length(nodes()))
    Enum.at(nodes(), index)
  end

  defp nodes do
    [:beam1@kata, :beam2@kata]
  end

end
