defmodule WechatPay.Plug.Notify do
  @moduledoc """
  Plug to handle callback from Wechat's payment gateway

  If the callback is success and verified, the `MyHandler.handle_success/2` is called with the
  `Plug.Conn.t` object and the result as a map.

  ## Example
      # Will call the handle_success/2 function on your handler
      plug WechatPay.Plug.Notify, handler: MyHandler

      # Will call the some_fun/2 function on your handler
      plug WechatPay.Plug.Notify, handler: {MyHandler, :some_fun}
  """

  import Plug.Conn

  alias WechatPay.Utils.XMLParser
  alias WechatPay.Utils.Signature

  @doc false
  def init([handler: {_mod, _fun}] = opts) do
    opts
  end
  def init([handler: mod]) do
    init([handler: {mod, :handle_success}])
  end

  @doc false
  def call(conn, [handler: {mod, fun}]) do
    {:ok, body, conn} = Plug.Conn.read_body(conn)

    data = XMLParser.parse(body)

    with {:ok, data} <- process_result(data),
      {:ok, data} <- verify_sign(data)
    do
      {:ok, conn} = apply(mod, fun, [conn, data])

      conn
      |> put_resp_content_type("application/xml")
      |> send_resp(:ok, success_response_body)
    else
      {:error, _reason} ->
        conn
        |> send_resp(:unprocessable_entity, "")
    end
  end

  defp success_response_body do
    ~s"""
      <xml>
        <return_code><![CDATA[SUCCESS]]></return_code>
        <return_msg><![CDATA[OK]]></return_msg>
      </xml>
    """
  end

  defp process_result(%{return_code: "SUCCESS"} = data) do
    {:ok, data}
  end
  defp process_result(%{return_code: "FAIL", return_msg: reason}) do
    {:error, reason}
  end

  defp verify_sign(data) do
    sign = data.sign

    calculated =
      data
      |> Map.delete(:sign)
      |> Signature.sign()

    if sign == calculated do
      {:ok, data}
    else
      {:error, "invalid signature"}
    end
  end
end
