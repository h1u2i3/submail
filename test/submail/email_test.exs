defmodule Submail.EmailTest do
  use ExUnit.Case, async: true

  defmodule Email do
    use Submail, appid: "appid", appkey: "appkey"
    use Submail.Email, project: "project"
  end

  test "should generate the right method" do
  end
end
