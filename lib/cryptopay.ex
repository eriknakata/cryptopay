defmodule Cryptopay do
  use HTTPoison.Base
  @moduledoc """
  Wrapper for Cryptopay REST API v2
  """

  defmodule Account do
    @enforce_keys [:id, :label, :currency, :balance, :balance_cents, :address]
    defstruct [:id, :label, :currency, :balance, :balance_cents, :address]
  end

  defmodule Ticker do
    @enforce_keys [:ask_rate, :bid_rate, :base_currency, :quote_currency]
    defstruct [:ask_rate, :bid_rate, :base_currency, :quote_currency]
  end

  defmodule Transaction do
    @enforce_keys [:id, :date, :timestamp, :amount, :amount_cents, :balance, :currency, :type, :reference, :description]
    defstruct [:id, :date, :timestamp, :amount, :amount_cents, :balance, :currency, :type, :reference, :description]
  end

  @doc """
  Retrieve all your Cryptopay accounts  
  """
  def get_accounts() do
    get_cryptopay("accounts", fn(json) ->
      Enum.reduce(json, [], fn(account, acc) ->
        List.insert_at(acc, 0, %Cryptopay.Account{
          id: account["id"],
          label: account["label"],
          currency: String.to_atom(account["currency"]),
          balance: Decimal.new(account["balance"]),
          balance_cents: account["balance_cents"],
          address: account["address"]
        })
      end)
    end)
  end

  @doc """
  Retrieve all transactions by account
  """
  def get_transaction(uuid) do
    get_cryptopay("accounts/#{uuid}/transactions", fn(json) ->
      Enum.reduce(json, [], fn(transaction, acc) ->
        List.insert_at(acc, 0, %Cryptopay.Transaction{
          amount: Decimal.new(transaction["amount"]),
          amount_cents: transaction["amount_cents"],
          balance: Decimal.new(transaction["balance"]),
          currency: String.to_atom(transaction["currency"]),
          date: transaction["date"],
          description: transaction["description"],
          id: transaction["id"],
          reference: transaction["reference"],
          timestamp: from_iso8601!(transaction["timestamp"]),
          type: transaction["type"]
        })
      end)
    end)
  end

  @doc """
  Generate a new BTC address for the account
  """
  def new_address(uuid) do
    get_cryptopay("accounts/#{uuid}/address", fn(json) -> json["address"] end)
  end

  @doc """
  Rate ticker details
  """
  def ticker_detail(from, to) do
    parse_to_ticker_struct = fn(json) ->
      %Cryptopay.Ticker{
        base_currency: String.to_atom(json["base_currency"]),
        quote_currency: String.to_atom(json["quote_currency"]),
        bid_rate: Decimal.new(json["bid_rate"]),
        ask_rate: Decimal.new(json["ask_rate"])
      }
    end

    get_cryptopay("tickers/#{from}/#{to}", parse_to_ticker_struct)
  end

  @doc """
  Retrieve all Cryptopay rate tickers
  """
  def tickers_rate do
    get_cryptopay("tickers", fn(json) ->
      Map.keys(json)
      |> Enum.reduce(%{}, fn(key, acc) -> Map.put(acc, key, %Cryptopay.Ticker{
        ask_rate: json[key]["ask_rate"],
        base_currency: json[key]["base_currency"],
        bid_rate: json[key]["bid_rate"],
        quote_currency: json[key]["quote_currency"]
      }) end)
    end)
  end

  defp get_cryptopay(url, parse_function) do
    case get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} -> {:ok, parse_function.(body)}
      {:error, %HTTPoison.Error{reason: reason}} -> {:error, reason}
      {:ok, %HTTPoison.Response{status_code: status_code, body: body}} -> {:error, "#{status_code} - #{body}"}
    end
  end

  defp process_url(url) do
    "https://private-anon-32b64f1230-cryptopayapi.apiary-mock.com/#{url}"
  end

  defp process_request_headers(headers) do
    headers ++ [
      {"Content-Type", "application/json"},
      {"x_api_key", "54c2f20bb32f78db0066a97b858f837b"}
    ]
  end

  defp process_response_body(body) do
    case Poison.decode(body) do
      {:ok, json} -> json
      {:error, _} -> body
    end
  end

  defp from_iso8601!(string_date) do
    {:ok, date, _} = DateTime.from_iso8601(string_date)
    date
  end

end