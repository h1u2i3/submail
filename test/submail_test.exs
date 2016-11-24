defmodule SubmailTest do
  use ExUnit.Case, async: true

  defmodule SubmailSms do
    use Submail, appid: "appid", appkey: "appkey"
  end

  test "should generate the functions" do
    functions = SubmailSms.__info__(:functions) |> Keyword.keys

    assert [:appid, :appkey] == functions
  end

  test "generated function should get the right value" do
    appid = SubmailSms.appid
    appkey = SubmailSms.appkey

    assert appid == "appid"
    assert appkey == "appkey"
  end
end
