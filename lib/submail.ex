defmodule Submail do
  @moduledoc """
  The module to add config data to other module.
  All config data include `appid` and `appkey`
  """

  defmacro __using__(config) do
    appid = config[:appid]
    appkey = config[:appkey]

    quote do
      @doc """
      Get the appid.
      """
      def appid, do: unquote(appid)

      @doc """
      Get the appkey.
      """
      def appkey, do: unquote(appkey)
    end
  end
end
