defmodule BankAccountElixir do
  defstruct balance: 0

  @moduledoc """
  Documentation for BankAccountElixir.
  """

  @doc """
  Bank Account

  ## Examples

      iex> BankAccountElixir.create()
      { :ok, %BankAccountElixir{balance: 0}}

  """
  def create() do
    {:ok, %BankAccountElixir{}}
  end

  def deposit(account, amount) when amount > 0 do
    newBalance = account.balance + amount
    {:ok, %BankAccountElixir{balance: newBalance}}
  end

  def deposit(_, _) do
    {:error, :amount_should_over_0}
  end

  def withdraw(account, amount) when amount > 0 do
    newBalance = account.balance - amount
    {:ok, %BankAccountElixir{balance: newBalance}}
  end

  def withdraw(_, _) do
    {:error, :amount_should_over_0}
  end
end
