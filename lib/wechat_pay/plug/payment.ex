defmodule WechatPay.Plug.Payment do
  @moduledoc """
  Plug behaviour to handle **Payment** Notification from Wechat's Payment Gateway.

  Official document: https://pay.weixin.qq.com/wiki/doc/api/jsapi.php?chapter=9_7

  ## Example

  ### Define a handler

  See `WechatPay.Plug.Handler` for how to implement a handler.

  ```elixir
  defmodule MyApp.WechatHandler do
    use WechatPay.Plug.Handler

    @impl WechatPay.Plug.Handler
    def handle_data(conn, data) do
      :ok
    end
  end
  ```

  ### Plug in

  In your app's `lib/my_app_web/router.ex`:

  ```elixir
  post "/wechat_pay/notification/payment", WechatPay.Plug.Payment, [handler: MyApp.WechatHandler, api_key: "my-api-key", sign_type: :md5]
  ```
  """

  alias WechatPay.Utils.XMLParser
  alias WechatPay.Utils.Signature
  alias WechatPay.Error

  import Plug.Conn

  @spec init(keyword()) :: [
          {:api_key, binary()} | {:handler, binary()} | {:sign_type, :md5 | :sha256}
        ]
  def init(opts) do
    handler = Keyword.get(opts, :handler)
    api_key = Keyword.get(opts, :api_key)
    sign_type = Keyword.get(opts, :sign_type)

    [sign_type: :md5]
    |> Keyword.merge(handler: handler, api_key: api_key, sign_type: sign_type)
  end

  @spec call(Plug.Conn.t(), [
          {:api_key, binary()} | {:handler, binary()} | {:sign_type, :md5 | :sha256}
        ]) ::
          Plug.Conn.t()
  def call(conn, handler: handler_module, api_key: api_key, sign_type: sign_type) do
    {:ok, body, conn} = Plug.Conn.read_body(conn)

    with {:ok, data} <- XMLParser.parse(body),
         :ok <- process_data(conn, data, handler_module, api_key, sign_type) do
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

  defp process_data(conn, data, handler_module, api_key, sign_type) do
    with {:ok, data} <- process_return_field(data),
         :ok <- Signature.verify(data, api_key, sign_type),
         :ok <- apply(handler_module, :handle_data, [conn, data]) do
      :ok
    else
      {:error, %Error{} = error} ->
        handle_error(handler_module, conn, error, data)

        {:error, error}
    end
  end

  defp process_return_field(%{return_code: "SUCCESS"} = data) do
    {:ok, data}
  end

  defp process_return_field(%{return_code: "FAIL", return_msg: reason}) do
    {:error, %Error{reason: reason, type: :failed_return}}
  end

  defp handle_error(handler_module, conn, error, data) do
    handler_module.handle_error(conn, error, data)
  end
end
