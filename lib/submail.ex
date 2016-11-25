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

      @doc """
      Helper method to add target.
      """
      def add_appid(struct, appid_string) when is_map(struct) do
        [{:appid, appid_string} | struct]
      end

      @doc """
      Helper method to add message.
      """
      def add_appkey(struct, appkey_string) when is_map(struct) do
        [{:appkey, appkey_string} | struct]
      end
    end

  end
end
