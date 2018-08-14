defmodule BankAccount do
  defstruct operations: []

  @moduledoc """
  Documentation for BankAccount.
  """

  @doc """
  Bank Account

  ## Examples

      iex> BankAccount.create()
      { :ok, %BankAccount{operations: []}}

  """
  def create() do
    {:ok, %BankAccount{}}
  end

  def deposit(account, amount) when amount > 0 do
    ops = account.operations ++ [amount]
    {:ok, %BankAccount{operations: ops}}
  end

  def deposit(_, _) do
    {:error, :amount_should_be_over_0}
  end

  def withdraw(account, amount) when amount > 0 do
    if canWithdraw(account, amount) do
      ops = account.operations ++ [-amount]
      {:ok, %BankAccount{operations: ops}}
    else
      {:error, :balance_is_not_enough}
    end
  end

  def withdraw(_, _) do
    {:error, :amount_should_be_over_0}
  end

  defp canWithdraw(account, amount) do
    balance(account) >= amount
  end

  def balance(account) do
    Enum.sum(account.operations)
  end
end
