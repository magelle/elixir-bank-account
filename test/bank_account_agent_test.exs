defmodule BankAccountAgentTest do
  use ExUnit.Case, async: true

  setup do
    {:ok, account} = BankAccountAgent.start_link([])
    %{account: account}
  end

  test "should create account", %{account: account} do
    assert BankAccountAgent.balance(account) == 0
  end

  test "should make a deposit", %{account: account} do
    BankAccountAgent.deposit(account, 100)
    BankAccountAgent.deposit(account, 10)
    assert BankAccountAgent.balance(account) == 110
  end

  test "should make a withdraw", %{account: account} do
    BankAccountAgent.deposit(account, 100)
    BankAccountAgent.withdraw(account, 10)
    assert BankAccountAgent.balance(account) == 90
  end

  test "deposit should return error when amount is negative", %{account: account} do
    assert BankAccountAgent.deposit(account, -10) == {:error, :amount_should_be_over_0}
    assert BankAccountAgent.balance(account) == 0
  end

  test "withdraw should return error when amount is negative", %{account: account} do
    assert BankAccountAgent.withdraw(account, -10) == {:error, :amount_should_be_over_0}
    assert BankAccountAgent.balance(account) == 0
  end

  test "are temporary workers" do
    assert Supervisor.child_spec(BankAccountAgent, []).restart == :temporary
  end
end
