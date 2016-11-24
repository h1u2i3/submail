defmodule Submail.Http do
  @moduledoc """
  Module to make http request.
  """

  @doc """
  Make a get request.
  """
  def get(url, params \\ []) do
    ensure_httpoison_started

    url
    |> HTTPoison.get([], params: params)
    |> parse_result
  end

  @doc """
  Make a post request.
  Because the submail all use `form submit`, we just set the
  content-type here.
  """
  def post(url, body, params \\ []) do
    ensure_httpoison_started

    headers = [{"Content-Type", "application/x-www-form-urlencoded"}]

    url
    |> HTTPoison.post(body, headers, params: params)
    |> parse_result
  end

  defp ensure_httpoison_started do
    :application.ensure_all_started(:httpoison)
  end

  defp decode_body(body)
  defp decode_body("{" <> _ = body), do: Poison.decode!(body, keys: :atoms)
  defp decode_body(body), do: body

  defp parse_result(result) do
    case result do
      {:ok, response} ->
        decode_body(response.body)
      {:error, error} ->
        {:error, error.reason}
    end
  end
end
