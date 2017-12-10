defmodule AccountsTest do
    use ExUnit.Case, async: true

    test "should return all cryotopay accounts" do
        {:ok, accounts} = Cryptopay.get_accounts()
        assert is_list(accounts)
    end

    test "should return all transactions by account" do
        {:ok, transactions} = Cryptopay.get_transaction("f4f787a2-78f4-49ed-ba41-e475ab4407cf")
        assert is_list(transactions)
    end

    test "should generate a new BTC address for the account" do
        {:ok, address} = Cryptopay.new_address("f4f787a2-78f4-49ed-ba41-e475ab4407cf")
        assert is_binary(address)
    end
end