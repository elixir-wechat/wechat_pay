defmodule WechatPay.Plug.Callback do
  defmodule Handler do
    @callback handle_success(Plug.Conn.t, map) :: any
    @callback handle_error(Plug.Conn.t, any, map) :: any
  end

  @moduledoc """
  Plug to handle callback from Wechat's payment gateway

  If the callback is success and verified, the result value will
  be assigned to private `:wechat_pay_result` key of the `Plug.Conn.t` object.

  ## Example

      defmodule MyApp.Web.WechatPayController do
        use MyApp.Web, :controller

        plug WechatPay.Plug.Callback, handler: MyApp.WechatPayCallbackHandler
      end

      defmodule MyApp.WechatPayCallbackHandler do
        @behaviour WechatPay.Plug.Callback.Handler

        def handle_success(conn, data) do
          IO.inspect data
          # %{
          #   appid: "wx2421b1c4370ec43b",
          #   attach: "支付测试",
          #   bank_type: "CFT",
          #   fee_type: "CNY",
          #   is_subscribe: "Y",
          #   mch_id: "10000100",
          #   nonce_str: "5d2b6c2a8db53831f7eda20af46e531c",
          #   openid: "oUpF8uMEb4qRXf22hE3X68TekukE",
          #   out_trade_no: "1409811653",
          #   result_code: "SUCCESS",
          #   return_code: "SUCCESS",
          #   sign: "594B6D97F089D24B55156CE09A5FF412",
          #   sub_mch_id: "10000100",
          #   time_end: "20140903131540",
          #   total_fee: "1",
          #   trade_type: "JSAPI",
          #   transaction_id: "1004400740201409030005092168"
          # }
        end

        def handle_error(conn, reason, data) do
          reason == "签名失败"
          data.return_code == "FAIL"
        end
      end
  """
  import Plug.Conn

  alias WechatPay.Utils.XMLParser
  alias WechatPay.Utils.Signature

  @spec init(keyword()) :: keyword()
  def init(opts) do
    opts
  end

  @doc """
  Process the data comes from Wechat's Payment Gateway.

  If the data is success and verified, the result value will
  be assigned to private `:wechat_pay_result` key of the `Plug.Conn.t` object.
  """
  @spec call(Plug.Conn.t, keyword()) :: Plug.Conn.t
  def call(conn, [handler: handler_module]) do
    {:ok, body, conn} = Plug.Conn.read_body(conn)

    data = XMLParser.parse(body)

    with(
      {:ok, data} <- process_result(data),
      {:ok, data} <- verify_sign(data)
    ) do
      apply(handler_module, :handle_success, [conn, data])

      conn
      |> response_with_success_info()
    else
      {:error, reason} ->
        apply(handler_module, :handle_error, [conn, reason, data])

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
