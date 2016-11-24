# Submail

Third-party [Submail](http://submail.cn) SDK.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add `submail` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:submail, github: "h1u2i3/submail"}]
    end
    ```

  2. Ensure `submail` is started before your application:

    ```elixir
    def application do
      [applications: [:submail]]
    end
    ```

## Send Sms

1. Use the `Submail.Sms` module

    ```elixir
      alias Submail.Sms

      %{}
      |> Sms.add_appid("appid")
      |> Sms.add_appkey("appkey")
      |> Sms.add_project("project")
      |> Sms.add_to("13888888888")
      |> Sms.add_vars(code: "132456")
      |> Sms.xsend
    ```

2. Create your own module:

    ```elixir
    defmodule Sms.Register do
      use Submail, appid: "appid", appkey: "appkey"
      use Submail.Sms, project: project
    end

    %{}
    |> Sms.Register.add_to("13888888888")
    |> Sms.Register.add_vars(code: "668726")
    |> Sms.Register.xsend
    ```

## TODO

- [x] Add base http request module.
- [x] Add sms `xsend`, `multixsend` support.
- [ ] Add email `xsend`, `send` support.
