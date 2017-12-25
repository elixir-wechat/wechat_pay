defmodule WechatPay.Plug.Refund do
  @moduledoc """
  Plug behaviour to handle **Refund** Notification from Wechat's Payment Gateway.

  Official document: https://pay.weixin.qq.com/wiki/doc/api/jsapi.php?chapter=9_16&index=9

  See `WechatPay.Handler` for how to implement a handler.
  """

  @callback init(opts :: Plug.opts) :: Plug.opts
  @callback call(conn :: Plug.Conn.t, opts :: Plug.opts) :: Plug.Conn.t

  alias WechatPay.Utils.XMLParser
  alias WechatPay.Error

  import Plug.Conn

  defmacro __using__(opts) do
    quote do
      @behaviour WechatPay.Plug.Refund

      mod = Keyword.fetch!(unquote(opts), :mod)

      defdelegate get_config, to: mod

      @impl true
      def init(opts) do
        handler = Keyword.get(opts, :handler)

        [handler: handler]
      end

      @impl true
      def call(conn, [handler: handler]),
        do: WechatPay.Plug.Refund.call(conn, [handler: handler], get_config())
    end
  end

  @doc false
  def call(conn, [handler: handler_module], config) do
    {:ok, body, conn} = Plug.Conn.read_body(conn)

    with(
      {:ok, data} <- XMLParser.parse_response(body),
      :ok <- process_data(conn, data, handler_module, config)
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

  defp process_data(conn, data, handler_module, config) do
    with(
      {:ok, data} <- process_return_field(data),
      {:ok, decrypted_data} <- decrypt_data(data, config),
      {:ok, map} <- XMLParser.parse_decrypted(decrypted_data),
      :ok <- apply(handler_module, :handle_data, [conn, map])
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

  defp decrypt_data(%{req_info: encrypted_data}, config) do
    api_key = Keyword.get(config, :apikey)

    key =
      :md5
      |> :crypto.hash(api_key)
      |> Base.encode16(case: :lower)

    {:ok, data} =
      encrypted_data
      |> Base.decode64()
 
    try do
      xml_string = :crypto.block_decrypt(:aes_ecb, key, data)

      {:ok, xml_string}
    rescue
      ArgumentError ->
        {:error, %Error{reason: "Fail to decrypt req_info", type: :fail_to_decrypt_req_info}}
    end
  end
  defp decrypt_data(_, _config) do
    {:error, %Error{reason: "Missing the encrypted `req_info` in response data", type: :missing_req_info}}
  end
end
