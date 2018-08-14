defmodule BankAccountTest do
  use ExUnit.Case
  doctest BankAccount

  test "should create account" do
    assert BankAccount.create() == {:ok, %BankAccount{}}
  end

  test "should make a deposit" do
    {:ok, account} = BankAccount.deposit(%BankAccount{}, 100)
    {:ok, account} = BankAccount.deposit(account, 10)
    assert BankAccount.balance(account) == 110
  end

  test "deposit should return error when amount is negative" do
    {:ok, account} = BankAccount.deposit(%BankAccount{}, 100)
    assert BankAccount.deposit(account, -10) == {:error, :amount_should_be_over_0}
  end

  test "should make a withdrawal" do
    {:ok, account} = BankAccount.deposit(%BankAccount{}, 100)
    {:ok, account} = BankAccount.withdraw(account, 10)
    assert BankAccount.balance(account) == 90
  end

  test "withdraw should return error when amount is negative" do
    {:ok, account} = BankAccount.deposit(%BankAccount{}, 100)
    assert BankAccount.withdraw(account, -10) == {:error, :amount_should_be_over_0}
  end

  test "withdraw should return error when balance is under amount to withdraw" do
    {:ok, account} = BankAccount.deposit(%BankAccount{}, 10)
    assert BankAccount.withdraw(account, 11) == {:error, :balance_is_not_enough}
  end
end
