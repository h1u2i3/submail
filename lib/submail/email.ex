defmodule Submail.Email do
  @moduledoc """
  Email send module.
  You can use this module to send email.

      alias Submail.Email

      []
      |> Email.set_appid("appid")
      |> Email.set_appkey("appkey")
      |> Email.add_to("leo@submail.cn", "leo")
      |> Email.set_sender("no-reply@submail.cn", "SUBMAIL")
      |> Email.set_test("test SDK text")
      |> Email.set_html("test SDK html")
      |> Email.set_subject("test SDK")
      |> Email.send
  """
  use Submail
  use Submail.Email.Base

  defmacro __using__(config) do
    quote do
      use Submail.Email.Base, unquote(config)
    end
  end
end
