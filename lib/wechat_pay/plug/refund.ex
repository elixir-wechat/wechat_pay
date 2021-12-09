defmodule WechatPay.Plug.Refund do
  @moduledoc """
  Plug behaviour to handle **Refund** Notification from Wechat's Payment Gateway.

  Official document: https://pay.weixin.qq.com/wiki/doc/api/jsapi.php?chapter=9_16&index=9

  ## Example

  ### Define a handler

  See `WechatPay.Plug.Handler` for how to implement a handler.

  ```elixir
  defmodule MyApp.WechatHandler do
    use WechatPay.Plug.Handler

    @impl WechatPay.Plug.Handler
    def handle_data(conn, _data) do
      :ok
    end
  end
  ```

  ### Plug in

  In your app's `lib/my_app_web/router.ex`:

  ```elixir
  post "/wechat_pay/notification/refund", WechatPay.Plug.Refund, [handler: MyApp.WechatHandler, api_key: "my-api-key"]
  ```
  """

  alias WechatPay.Utils.XMLParser
  alias WechatPay.Error

  import Plug.Conn

  @spec init(keyword()) :: [{:api_key, any()} | {:handler, any()}]
  def init(opts) do
    handler = Keyword.get(opts, :handler)
    api_key = Keyword.get(opts, :api_key)

    [handler: handler, api_key: api_key]
  end

  @spec call(Plug.Conn.t(), [{:api_key, any()} | {:handler, any()}]) :: Plug.Conn.t()
  def call(conn, handler: handler_module, api_key: api_key) do
    {:ok, body, conn} = Plug.Conn.read_body(conn)

    with {:ok, data} <- XMLParser.parse(body),
         :ok <- process_data(conn, data, handler_module, api_key) do
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

  defp process_data(conn, data, handler_module, api_key) do
    with {:ok, data} <- process_return_field(data),
         {:ok, decrypted_data} <- decrypt_data(data, api_key),
         {:ok, map} <- XMLParser.parse(decrypted_data, "root"),
         :ok <- apply(handler_module, :handle_data, [conn, map]) do
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

  defp decrypt_data(%{req_info: encrypted_data}, api_key) do
    key =
      :md5
      |> :crypto.hash(api_key)
      |> Base.encode16(case: :lower)

    {:ok, data} =
      encrypted_data
      |> Base.decode64()

    try do
      xml_string = crypto_block_decrypt(:aes_256_ecb, key, data)
      {:ok, xml_string}
    rescue
      ArgumentError ->
        {:error, %Error{reason: "Fail to decrypt req_info", type: :fail_to_decrypt_req_info}}
    end
  end

  defp decrypt_data(_, _api_key) do
    {:error,
     %Error{reason: "Missing the encrypted `req_info` in response data", type: :missing_req_info}}
  end

  # https://erlang.org/doc/apps/crypto/new_api.html#the-new-api
  if Code.ensure_loaded?(:crypto) && function_exported?(:crypto, :crypto_one_time, 4) do
    defp crypto_block_decrypt(algorithm, key, data) do
      :crypto.crypto_one_time(algorithm, key, data, false)
    end
  else
    defp map_algorithm(:aes_256_ecb), do: :aes_ecb

    defp crypto_block_decrypt(algorithm, key, data) do
      :crypto.block_decrypt(map_algorithm(algorithm), key, data)
    end
  end
end
