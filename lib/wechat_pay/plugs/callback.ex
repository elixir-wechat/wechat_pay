defmodule WechatPay.Plug.Callback do
  defmodule Handler do
    @moduledoc """
    The behaviour for callback handler.
    """

    @callback handle_data(conn :: Plug.Conn.t, data :: map) :: :ok | {:error, any}
    @callback handle_error(conn :: Plug.Conn.t, error :: WechatPay.Error.t, data :: map) :: any

    @optional_callbacks handle_error: 3
  end

  @moduledoc """
  Plug to handle callback from Wechat's payment gateway

  If the data is valid, the Handler's `handle_data/2` will be called,
  otherwise the `handle_error/3` will be called

  ## A Phoenix Example

  Mount the Plug in router:

  ```elixir
  # lib/my_app/web/router.ex
  post "/wechat-pay/callback", WechatPay.Plug.Callback, [handler: MyApp.WechatPay.CallbackHandler]
  ```

  Implement your own handler:

  ```elixir
  # lib/my_app/wechat_pay/callback_handler.ex
  defmodule MyApp.WechatPay.CallbackHandler do
    @behaviour WechatPay.Plug.Callback.Handler

    @impl true
    def handle_data(conn, data) do
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

    # optional
    @impl true
    def handle_error(conn, reason, data) do
      reason == "签名失败"
      data.return_code == "FAIL"
    end
  end
  ```
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
    try do
      handler_module.handle_error(conn, error, data)
    rescue
      UndefinedFunctionError ->
        :undefined
    end
  end
end
