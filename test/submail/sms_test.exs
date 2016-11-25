defmodule Submail.SmsTest do
  use ExUnit.Case, async: true

  defmodule Demo do
    use Submail, appid: "appid", appkey: "appkey"
    use Submail.Sms, project: "project"
  end

  setup do
    {:ok, _} = :application.ensure_all_started(:httparrot)
    :ok
  end

  test "should generate the methods" do
    functions = Demo.__info__(:functions) |> Keyword.keys

    assert :project in functions
    assert :xsend in functions
    assert :multixsend in functions
  end

  test "xsend should post with the right body" do
    result = Demo.xsend(to: "target", vars: %{code: "556879"})

    form = result.form

    assert form == %{appid: "appid", project: "project", signature: "appkey",
             to: "target", vars: "{\"code\":\"556879\"}"}
  end

  test "multixsend should post with the right body" do
    result = Demo.multixsend(multi: [%{to: "target", vars: %{code: "567896"}}])

    form = result.form

    assert form == %{appid: "appid",
      multi: "[{\"vars\":{\"code\":\"567896\"},\"to\":\"target\"}]",
      project: "project", signature: "appkey"}
  end
end
