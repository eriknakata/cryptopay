defmodule Cryptopay do
  use HTTPoison.Base
  @moduledoc """
  Wrapper for Cryptopay REST API v2
  """

  @doc """
  Rate ticker details
  
  """
  def ticker_detail(from, to) do
    case get("tickers/#{from}/#{to}") do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} -> {:ok, parse_to_ticker_struct(body)}
      {:error, %HTTPoison.Error{reason: reason}} -> {:error, reason}
      {:ok, %HTTPoison.Response{status_code: status_code, body: body}} -> {:error, "#{status_code} - #{body}"}
    end
  end

  defp parse_to_ticker_struct(json) do
    json
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

end
