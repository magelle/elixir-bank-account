defmodule PartitionedBank do
  use GenServer

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts)
  end

  def create_account(bank, accountId) do
    GenServer.call(bank, {:create, accountId})
  end

  def get_account(bank, accountId) do
    GenServer.call(bank, {:get, accountId})
  end

  def transfer(bank, debtorAccountId, creditorAccountId, amount) do
    with {:ok, debtorAccount, creditorAccount} <- getBoth(bank, debtorAccountId, creditorAccountId),
         :ok <- Router.route(debtorAccountId, BankAccountAgent, :withdraw, [debtorAccount, amount]),
         do: Router.route(creditorAccountId, BankAccountAgent, :deposit, [creditorAccount, amount])
  end

  defp getBoth(bank, accountId1, accountId2) do
    result1 = get(bank, accountId1)
    result2 = get(bank, accountId2)
    case {result1, result2} do
      {{:ok, account1}, {:ok, account2}} -> {:ok, account1, account2}
      {{:error, errorMsg}, _} -> {:error, errorMsg}
      {_, {:error, errorMsg}} -> {:error, errorMsg}
    end
  end

  defp get(bank, debtorAccountId) do
    case get_account(bank, debtorAccountId) do
      {:ok, debtorAccount} -> {:ok, debtorAccount}
      :error -> {:error, :unknown_account}
    end
  end

  @impl true
  def init(_opts) do
    {:ok, %{}}
  end

  @impl true
  def handle_call({:create, accountId}, _from, accounts) do
    {:ok, newAccount} = Router.route(accountId, BankAccountAgent, :create, [])
    accounts = Map.put(accounts, accountId, newAccount)
    {:reply, {:ok, newAccount}, accounts}
  end

  @impl true
  def handle_call({:get, accountId}, _from, accounts) do
    if (Map.has_key?(accounts, accountId)) do
      account = Map.get(accounts, accountId)
      {:reply, {:ok, account}, accounts}
    else
      {:reply, :error, accounts}
    end
  end

end
