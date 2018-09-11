defmodule BankAccountAgent do
  use Agent, restart: :temporary

  def start_link(_opts) do
    {:ok, account} = BankAccount.create()
    Agent.start_link(fn -> account end)
  end

  @doc """
  Return the balance of the account
  """
  def balance(accountRef) do
    Agent.get(accountRef, &BankAccount.balance(&1))
  end

  @doc """
  Make a deposit
  """
  def deposit(accountRef, amount) do
    account = Agent.get(accountRef, fn account -> account end)
    res = BankAccount.deposit(account, amount)
    update(accountRef, res)
  end

  @doc """
  Make a withdrawal
  """
  def withdraw(accountRef, amount) do
    account = Agent.get(accountRef, fn account -> account end)
    res = BankAccount.withdraw(account, amount)
    update(accountRef, res)
  end

  defp update(accountRef, {:ok, account}) do
    Agent.update(accountRef, fn _ -> account end)
    :ok
  end

  defp update(_, {:error, errorMsg}) do
    {:error, errorMsg}
  end
end
