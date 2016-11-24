defmodule Submail.Helper do
  @moduledoc """
  Helper method used in other modules.
  """

  @doc """
  Transform the `Map` in to form submit data.

      iex>Submail.Helper.map_to_form(%{foo: "bar"})
      "foo=bar"

      iex>Submail.Helper.map_to_form(%{foo: %{one: "bar"}})
      "foo={\\"one\\":\\"bar\\"}"
  """
  def map_to_form(map, result \\ [])
  def map_to_form(map, []) when is_map(map) do
    map |> Map.to_list |> map_to_form([])
  end
  def map_to_form([], result), do: result |> Enum.join("&")
  def map_to_form([{key, value} | tail], result) when is_binary(value) do
    tail |> map_to_form(["#{key}=#{value}" | result])
  end
  def map_to_form([{key, value} | tail], result) when is_map(value) do
    value = value |> Poison.encode!
    tail |> map_to_form(["#{key}=#{value}" | result])
  end

  @doc """
  Remove the item if the value is nil in map.

      iex>Submail.Helper.remove_nil(%{one: nil, two: 2})
      %{two: 2}
  """
  def remove_nil(map) when is_map(map) do
    map
    |> Enum.reject(fn({key, value}) -> value == nil end)
    |> Enum.into(%{})
  end

  @doc """
  Transform from the `struct` to form submit data.

      iex>Submail.Helper.struct_to_form(%Submail.Sms.Single{to: "223344"})
      "to=223344"
  """
  def struct_to_form(struct) do
    struct
    |> Map.from_struct
    |> remove_nil
    |> map_to_form
  end
end
