defmodule Submail.Helper do
  @moduledoc """
  Helper method used in other modules.
  """
  @doc """
  Remove the item if the value is nil in map.

      iex>Submail.Helper.remove_nil(%{one: nil, two: 2})
      %{two: 2}
  """
  def remove_nil(map) when is_map(map) do
    map
    |> Enum.reject(fn({_key, value}) -> value == nil end)
    |> Enum.into(%{})
  end

  @doc """
  Transform from the `struct` to form submit data.

      iex>Submail.Helper.struct_to_form_map(%Submail.Sms.Base.Single{to: "234"})
      [to: "234"]
  """
  def struct_to_form_map(struct) do
    struct
    |> Map.from_struct
    |> remove_nil
    |> to_form_map
  end

  @doc """
  Transform from map to keyword

      iex>Submail.Helper.to_form_map([foo: %{foo: "bar"}])
      [foo: "{\\"foo\\":\\"bar\\"}"]
  """
  def to_form_map(map, result \\ [])
  def to_form_map(map, []) when is_list(map) do
    to_form_map(map |> Enum.into(%{}), [])
  end
  def to_form_map(map, []) when is_map(map) do
    map
    |> Enum.map(fn({key, value}) ->
         cond do
           is_binary(value) -> {key, value}
           true -> {key, Poison.encode!(value)}
         end
       end)
  end
end
