defmodule Submail.Sms.Base do
  @moduledoc """
  Define the methods needed for send sms.
  You can use this module to build you own module to send sms,
  normally one project should build a module.

      defmodule Sms.Code do
        use Submail, appid: "appid", appkey: "appkey"
        use Submail.Sms, project: "project"
      end

      []
      |> Sms.Code.add_to("13888888888")
      |> Sms.Code.add_vars(code: "132456")
      |> Sms.Code.xsend
  """

  defmacro __using__(config) do
    project = config[:project] || nil

    quote do
      import Submail.Helper

      alias Submail.Http
      alias Submail.Sms.Base.Single
      alias Submail.Sms.Base.Multi

      @endpoint       "https://api.submail.cn/message"
      @test_url       "http://localhost:8080/post"

      if Mix.env == :test do
        @xsend_url      @test_url
        @multixsend_url @test_url
      else
        @xsend_url      @endpoint <>"/xsend"
        @multixsend_url @endpoint <> "/multixsend"
      end

      @doc """
      Helper method to add target.
      """
      def add_to(struct, cellphone) when is_list(struct) do
        [{:to, cellphone} | struct]
      end

      @doc """
      Helper method to add message.
      """
      def add_vars(struct, params) when is_list(struct) do
        [{:vars, params |> Enum.into(%{})} | struct]
      end

      @doc """
      Helper method to add project
      """
      def add_project(struct, project) when is_list(struct) do
        [{:project, project} | struct]
      end

      @doc """
      Helper method to add multi in multixsend.
      """
      def add_multi(struct, multi) when is_list(struct) do
        [{:multi, multi |> Enum.into(%{})} | struct]
      end

      @doc """
      Return the project the sms template use.
      """
      def project, do: unquote(project)

      @doc """
      Single send sms with `xsend`
      """
      def xsend(struct) when is_list(struct) do
        struct = Single
                 |> struct(struct |> add_config_data)
                 |> struct_to_form_map

        Http.post(@xsend_url, {:form, struct})
      end

      @doc """
      Send lots of sms with `multixsend`
      """
      def multixsend(struct) when is_list(struct) do
        struct = Multi
                 |> struct(struct |> add_config_data)
                 |> struct_to_form_map

        Http.post(@multixsend_url, {:form, struct})
      end

      defp add_config_data(struct) do
        struct
        |> Keyword.put_new(:project, project)
        |> Keyword.put_new(:appid, appid)
        |> Keyword.put_new(:signature, appkey)
      end
    end
  end

  defmodule Single do
    @moduledoc false

    defstruct appid: nil, to: nil, project: nil, vars: nil,
      timestamp: nil, sign_type: nil, signature: nil
  end

  defmodule Multi do
    @moduledoc false

    defstruct appid: nil, project: nil, multi: nil, timestamp: nil,
      sign_type: nil, signature: nil
  end
end
