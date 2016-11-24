defmodule Submail.Sms do
  @moduledoc """
  Define the methods needed for send sms.
  You can use this module to build you own module to send sms,
  normally one project should build a module.

      alias Submail.Sms

      %{}
      |> Sms.add_appid("appid")
      |> Sms.add_appkey("appkey")
      |> Sms.add_project("project")
      |> Sms.add_to("13888888888")
      |> Sms.add_vars(code: "132456")
      |> Sms.xsend
  """
  use Submail
  use Submail.Sms.Base

  @doc """
  Helper method to add target.
  """
  def add_appid(struct, appid) when is_map(struct) do
    struct |> Map.put(:appid, appid)
  end

  @doc """
  Helper method to add message.
  """
  def add_appkey(struct, appkey) when is_map(struct) do
    struct |> Map.put(:signature, appkey)
  end

  defmacro __using__(config) do
    quote do
      use Submail.Sms.Base, unquote(config)
    end
  end

end
