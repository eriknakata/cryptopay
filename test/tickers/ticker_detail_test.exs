defmodule TickerDetailTest do
    use ExUnit.Case, async: true

    test "should return a ticker detail" do
        assert {:ok, %Cryptopay.Ticker{base_currency: "BTC", quote_currency: "USD"}} = Cryptopay.ticker_detail("btc", "usd")
    end
end