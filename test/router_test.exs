defmodule RouterTest do
  use ExUnit.Case, async: true

  @tag :distributed
  test "route requests across nodes" do
    assert Router.printNodeName(:beam1@kata) == :beam1@kata
    assert Router.printNodeName(:beam2@kata) == :beam2@kata
  end

end
