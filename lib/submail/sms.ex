defmodule Submail.Sms do
  @moduledoc """
  Define the methods needed for send sms.
  You can use this module to build you own module to send sms,
  normally one project should build a module.

      defmodule Sms.Code do
        use Submail, appid: "appid", appkey: "appkey"
        use Submail.Sms, project: "project"
      end

      %{}
      |> Code.add_to("13888888888")
      |> Code.add_vars(code: "132456")
      |> Code.xsend
  """

  @doc """
  Helper method to add target.
  """
  def add_to(struct, cellphone) do
    struct |> Map.put(:to, cellphone)
  end

  @doc """
  Helper method to add message.
  """
  def add_vars(struct, params) do
    struct |> Map.put(:vars, params |> Enum.into(%{}))
  end

  @doc """
  Helper method to add project
  """
  def add_project(struct, project) do
    struct |> Map.put(:project, project)
  end

  @doc """
  Helper method to add multi in multixsend.
  """
  def add_multi(struct, multi) do
    struct |> Map.put(:multi, multi |> Enum.into(%{}))
  end

  defmacro __using__(config) do
    project = config[:project] || nil

    quote do
      import unquote(__MODULE__)
      import Submail.Helper

      alias Submail.Http
      alias Submail.Sms.Single
      alias Submail.Sms.Multi

      @endpoint       "https://api.submail.cn/message"
      @xsend_url      @endpoint <>"/xsend"
      @multixsend_url @endpoint <> "/multixsend"

      @doc """
      Return the project the sms template use.
      """
      def project, do: unquote(project)

      @doc """
      Single send sms with `xsend`
      """
      def xsend(struct) do
        struct = struct |> add_config_data
        data = struct(Single, struct) |> struct_to_form
        Http.post(@xsend_url, data)
      end

      @doc """
      Send lots of sms with `multixsend`
      """
      def multixsend(struct) do
        struct = struct |> add_config_data
        data = struct(Multi, struct) |> struct_to_form
        Http.post(@multixsend_url, data)
      end

      defp add_config_data(struct) do
        struct
        |> Map.put_new_lazy(:project, &project/0)
        |> Map.put(:appid, appid)
        |> Map.put(:signature, appkey)
      end
    end
  end

  defmodule Single do
    @moduledoc false

    import Submail.Helper

    defstruct appid: nil, to: nil, project: nil, vars: nil,
      timestamp: nil, sign_type: nil, signature: nil
  end

  defmodule Multi do
    @moduledoc false

    defstruct appid: nil, project: nil, multi: nil, timestamp: nil,
      sign_type: nil, signature: nil
  end
end
