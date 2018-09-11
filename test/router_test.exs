defmodule RouterTest do
  use ExUnit.Case, async: true

  @tag :distributed
  test "route requests across nodes" do
    assert Router.printNodeName("0") == :beam1@kata
    assert Router.printNodeName("1") == :beam2@kata
  end

  test "should distrubute nodes by accountId" do
    assert Router.getNode("1") == :beam2@kata
    assert Router.getNode("2") == :beam1@kata
    assert Router.getNode("3") == :beam2@kata
    assert Router.getNode("4") == :beam1@kata
    assert Router.getNode("5") == :beam2@kata
    assert Router.getNode("6") == :beam1@kata
    assert Router.getNode("7") == :beam2@kata
    assert Router.getNode("8") == :beam1@kata
    assert Router.getNode("9") == :beam2@kata
    assert Router.getNode("0") == :beam1@kata
  end
end
