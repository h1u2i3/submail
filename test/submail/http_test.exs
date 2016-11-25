defmodule Submail.HttpTest do
  use ExUnit.Case, asycn: true
  import :meck

  alias Submail.Http

  @get  "http://localhost:8080/get"
  @post "http://localhost:8080/post"
  @headers "http://localhost:8080/headers"

  setup do
    {:ok, _} = :application.ensure_all_started(:httparrot)
    :ok
  end

  test "make get request should get response" do
    result = Http.get(@get)

    assert result
  end

  test "make get request should set the params" do
    result = Http.get(@get, foo: "bar")

    params = result.args

    assert params == %{foo: "bar"}
  end

  test "make post request should get response" do
    result = Http.post(@post, "body")

    assert result
  end

  test "make post request with the right headers" do
    result = Http.post(@post, "body")

    content_type = result.headers[:"content-type"]

    assert content_type == "application/x-www-form-urlencoded"
  end

  test "make post request with the right body" do
    result = Http.post(@post, "foo=bar&age=17")

    form = result.form

    assert form == %{foo: "bar", age: "17"}
  end

  test "should return error when get with error" do
    make_hackney_meck
    result = Http.get(@headers, [])

    assert result == {:error, {:closed, "Something happened"}}
    unload_hackney_meck
  end

  test "should return error when post with error" do
    make_hackney_meck
    result = Http.post(@headers, "post=some")

    assert result == {:error, {:closed, "Something happened"}}
    unload_hackney_meck
  end

  test "check multipart post" do
    #result = Http.post(@post, {:multipart, [{:file, "/etc/hosts", { ["form-data"], [name: "\"attachmens[]\""] }, []}, foo: "bar"]})
    #result = Http.post(@post, {:multipart, [{:file, "test/test_helper.exs"}, {"name", "value"}]})
    #result = System.cmd("curl", ~w<http://localhost:8080/post -F foo=bar -F attachments[]=@/Users/xiaohui/Desktop/y.jpg>)
    result = Http.post(@post, {:multipart, [{"signature", "bed98302d2d8ad842fe07d88bc2e1be5"}, {"appid", "11885"},
                              {:file, "/Users/xiaohui/Desktop/y.jpg",
                                {["form-data"], [name: "\"attachments[]\"", filename: "\"/Users/xiaohui/Desktop/y.jpg\""]}, []}, {"subject", "Test Mail"},
   {"text", "Hello!"}, {"from", "support@yimei.io"}, {"to", "286390860@qq.com"}]})
    # result = Http.post @post, {:multipart, [{:file, "/etc/hosts", { ["form-data"], [name: "\"photo\"", filename: "\"/etc/hosts\""]},[]}]}
    refute result
  end

  defp make_hackney_meck do
    new :hackney
    reason = {:closed, "Something happened"}
    expect(:hackney, :request, 5, {:error, reason})
  end

  def unload_hackney_meck do
    unload
  end
end
