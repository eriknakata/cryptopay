defmodule TickersRateTest do
    use ExUnit.Case, async: true

    test "should return a lista of ticker detail" do
        assert 1 = Cryptopay.tickers_rate()
    end
end