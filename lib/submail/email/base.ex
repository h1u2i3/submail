defmodule Submail.Email.Base do
  @moduledoc """
  Define the methods needed for send email.
  You can use this module to build you own module to send email,
  normally one project should build a module.
defmodule Email.Welcome do
        use Submail, appid: "appid", appkey: "appkey"
        use Submail.Email, project: "project"
      end

      alias Email.Welcome

      []
      |> Welcome.add_to("leo@submail.cn", "leo")
      |> Welcome.set_sender("no-reply@submail.cn", "SUBMAIL")
      |> Welcome.set_text("test SDK text")
      |> Welcome.set_html("test SDK html")
      |> Welcome.set_subject("test SDK")
      |> Welcome.send
  """
  defmacro __using__(config) do
    project = config[:project] || nil

    quote do
      import Submail.Helper

      alias Submail.Http
      alias Submail.Email.Base.Mail

      @endpoint       "https://api.submail.cn/mail"
      @test_url       "http://localhost:8080/post"

      if Mix.env == :test do
        @send_url      @test_url
        @xsend_url     @test_url
      else
        @send_url      @endpoint <> "/send"
        @xsend_url     @endpoint <> "/xsend"
      end

      @doc """
      Helper method to add target.
      """
      def add_to(struct, email, name \\ "") when is_list(struct) do
        to = struct |> Keyword.get(:to, "")

        case to do
          "" -> struct |> Keyword.put(:to, email_string(email, name))
          _  -> struct |> Keyword.put(:to, to <> "," <> email_string(email, name))
        end
      end

      @doc """
      Helper method to add sender.
      """
      def set_sender(struct, email, name \\ "") when is_list(struct) do
         [{:from_name, name} | [{:from, email} | struct]]
      end

      @doc """
      Helper method to add text.
      """
      def set_text(struct, text) when is_list(struct) do
        [{:text, text} | struct]
      end

      @doc """
      Helper method to add text.
      """
      def set_html(struct, html) when is_list(struct) do
        [{:html, html} | struct]
      end

      @doc """
      Helper method to add subject.
      """
      def set_subject(struct, subject) when is_list(struct) do
        [{:subject, subject} | struct]
      end

      @doc """
      Helper method to add attachments.
      """
      def add_attachment(struct, path) when is_list(struct) do
        [{:file, path, { ["form-data"], [name: "\"attachments[]\"",
            filename: "\"#{path}\""] }, []} | struct]
      end

      @doc """
      Return the project the sms template use.
      """
      def project, do: unquote(project)

      @doc """
      Send email thourgh send method.
      """
      def send(struct) when is_list(struct) do
        struct = struct
                 |> Keyword.put_new(:appid, appid)
                 |> Keyword.put_new(:signature, appkey)

        if List.keyfind(struct, :file, 0) do
          Http.post(@send_url, {:multipart, struct |> to_string_key})
        else
          Http.post(@send_url, {:form, struct})
        end
      end

      @doc """
      Send email through xsend method.
      """
      def xsend(struct) when is_list(struct) do
        struct = struct
                 |> Keyword.put_new(:appid, appid)
                 |> Keyword.put_new(:singature, appkey)
                 |> Keyword.put_new(:project, project)

        struct = struct(XMail, struct)
                 |> to_form_map

        Http.post(@xsend_url, {:form, struct})
      end

      defp to_string_key(struct) when is_list(struct) do
        struct
        |> Enum.map(fn(item) ->
             case item do
               {key, value} -> {to_string(key), value}
               _            -> item
             end
           end)
      end

      defp email_string(email, name \\ "") do
        if name != "" do
          "#{name} <#{email}>"
        else
          email
        end
      end
    end
  end

  defmodule XMail do
    @moduledoc false
    defstruct appid: nil, to: nil, addressbook: nil, from: nil,
      from_name: nil, reply: nil, cc: nil, bcc: nil, subject: nil,
      project: nil, vars: nil, links: nil, headers: nil,
      asynchronous: nil, tag: nil, timestamp: nil, sign_type: nil,
      signature: nil
  end
end
