defmodule BankTest do
  use ExUnit.Case, async: true

  setup context do
    _ = start_supervised!({Bank, name: context.test})
    %{bank: context.test}
  end

  test "Create an account", %{bank: bank} do
    assert Bank.get_account(bank, "myAccountId") == :error

    Bank.create_account(bank, "myAccountId")
    assert {:ok, account} = Bank.get_account(bank, "myAccountId")

    BankAccountAgent.deposit(account, 100)
    assert BankAccountAgent.balance(account) == 100
  end

  test "Transaction between two accounts", %{bank: bank} do
    Bank.create_account(bank, "debtor_account")
    Bank.create_account(bank, "creditor_account")

    {:ok, debtor_account} = Bank.get_account(bank, "debtor_account")
    BankAccountAgent.deposit(debtor_account, 100)

    {:ok, creditor_account} = Bank.get_account(bank, "creditor_account")
    BankAccountAgent.deposit(creditor_account, 100)

    assert Bank.transfer(bank, "debtor_account", "creditor_account", 10) == :ok

    assert BankAccountAgent.balance(debtor_account) == 90
    assert BankAccountAgent.balance(creditor_account) == 110
  end

  test "Transaction when debtor account does not exists", %{bank: bank} do
    Bank.create_account(bank, "creditor_account")

    assert Bank.transfer(bank, "unknown_account", "creditor_account", 10) ==
             {:error, :unknown_account}

    {:ok, creditor_account} = Bank.get_account(bank, "creditor_account")
    assert BankAccountAgent.balance(creditor_account) == 0
  end

  test "Transaction when creditor account does not exists", %{bank: bank} do
    Bank.create_account(bank, "debtor_account")
    {:ok, debtor_account} = Bank.get_account(bank, "debtor_account")
    BankAccountAgent.deposit(debtor_account, 100)

    assert Bank.transfer(bank, "debtor_account", "unknown_account", 10) ==
             {:error, :unknown_account}

    assert BankAccountAgent.balance(debtor_account) == 100
  end

  test "Transaction when debtor account does not have enough money", %{bank: bank} do
    Bank.create_account(bank, "debtor_account")
    Bank.create_account(bank, "creditor_account")

    {:ok, debtor_account} = Bank.get_account(bank, "debtor_account")
    BankAccountAgent.deposit(debtor_account, 9)

    {:ok, creditor_account} = Bank.get_account(bank, "creditor_account")
    BankAccountAgent.deposit(creditor_account, 100)

    assert Bank.transfer(bank, "debtor_account", "creditor_account", 10) ==
             {:error, :balance_is_not_enough}

    assert BankAccountAgent.balance(debtor_account) == 9
    assert BankAccountAgent.balance(creditor_account) == 100
  end
end
