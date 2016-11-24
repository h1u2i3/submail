defmodule Submail.SmsTest do
  use ExUnit.Case, async: true

  defmodule Demo do
    use Submail, appid: "appid", appkey: "appkey"
    use Submail.Sms, project: "project"
  end

  test "should generate the method project" do
    functions = Demo.__info__(:functions) |> Keyword.keys

    assert :project in functions
    assert :xsend in functions
    assert :multixsend in functions
  end

  test "xsend should post with the right body" do
  end

  test "multixsend should post with the right body" do
  end
end
