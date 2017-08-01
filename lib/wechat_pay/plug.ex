defmodule WechatPay.Plug do
  @moduledoc """
  Plug to handle callback from Wechat's payment gateway

  If the data is valid, the Handler's `handle_data/2` will be called,
  otherwise the `handle_error/3` will be called

  ## Phoenix Example

  ```elixir
  # lib/my_app/web/router.ex
  post "/wechat-pay/callback", WechatPay.Plug, [handler: MyApp.WechatCallbackHandler]
  ```

  See `WechatPay.CallbackHandler` for how to implement a handler.
  """

  @behaviour Plug
  import Plug.Conn

  alias WechatPay.Utils.XMLParser
  alias WechatPay.Utils.Signature
  alias WechatPay.Error

  @impl Plug
  def init(opts) do
    handler = Keyword.get(opts, :handler)

    [handler: handler]
  end

  @impl Plug
  def call(conn, [handler: handler_module]) do
    {:ok, body, conn} = Plug.Conn.read_body(conn)

    with(
      {:ok, data} <- XMLParser.parse(body),
      :ok <- process_data(conn ,data, handler_module)
    ) do
      response_with_success_info(conn)
    else
      {:error, %Error{reason: reason}} ->
        conn
        |> send_resp(:unprocessable_entity, reason)
    end
  end

  defp response_with_success_info(conn) do
    body = ~s"""
      <xml>
        <return_code><![CDATA[SUCCESS]]></return_code>
        <return_msg><![CDATA[OK]]></return_msg>
      </xml>
    """

    conn
    |> put_resp_content_type("application/xml")
    |> send_resp(:ok, body)
  end

  defp process_data(conn, data, handler_module) do
    with(
      {:ok, data} <- process_return_field(data),
      :ok <- Signature.verify(data),
      :ok <- apply(handler_module, :handle_data, [conn, data])
    ) do
      :ok
    else
      {:error, %Error{} = error} ->
        maybe_handle_error(handler_module, conn, error, data)

        {:error, error}
    end
  end

  defp process_return_field(%{return_code: "SUCCESS"} = data) do
    {:ok, data}
  end
  defp process_return_field(%{return_code: "FAIL", return_msg: reason}) do
    {:error, %Error{reason: reason, type: :failed_return}}
  end

  defp maybe_handle_error(handler_module, conn, error, data) do
    handler_module.handle_error(conn, error, data)
  end
end
