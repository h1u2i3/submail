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

## TODO

- [ ] Add base http request module.
- [ ] Add sms `xsend`, `multixsend` support.
