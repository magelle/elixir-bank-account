defmodule BankAccountElixirTest do
  use ExUnit.Case
  doctest BankAccountElixir

  test "should create account" do
    assert BankAccountElixir.create() == {:ok, %BankAccountElixir{balance: 0}}
  end

  test "should make a deposit" do
    assert BankAccountElixir.deposit(%BankAccountElixir{balance: 10}, 100) ==
             {:ok, %BankAccountElixir{balance: 110}}
  end

  test "deposit should return error when amount is negative" do
    assert BankAccountElixir.deposit(%BankAccountElixir{balance: 10}, -10) ==
             {:error, :amount_should_over_0}
  end

  test "should make a withdrawal" do
    assert BankAccountElixir.withdraw(%BankAccountElixir{balance: 100}, 10) ==
             {:ok, %BankAccountElixir{balance: 90}}
  end

  test "withdraw should return error when amount is negative" do
    assert BankAccountElixir.withdraw(%BankAccountElixir{balance: 10}, -10) ==
             {:error, :amount_should_over_0}
  end
end
