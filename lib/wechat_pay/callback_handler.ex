defmodule WechatPay.CallbackHandler do
  @moduledoc """
  Implement your own handler:

  ```elixir
  # lib/my_app/wechat_callback_handler.ex
  defmodule MyApp.WechatCallbackHandler do
    use WechatPay.CallbackHandler

    @impl WechatPay.CallbackHandler
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

    # This is optional
    @impl WechatPay.CallbackHandler
    def handle_error(conn, error, data) do
      Logger.error(inspect(error))
    end
  end
  """

  defmacro __using__(_opts) do
    quote do
      @behaviour WechatPay.CallbackHandler

      @impl WechatPay.CallbackHandler
      def handle_error(conn, error, data) do
        :nothing
      end

      defoverridable [handle_error: 3]
    end
  end

  @callback handle_data(conn :: Plug.Conn.t, data :: map) :: :ok | {:error, any}
  @callback handle_error(conn :: Plug.Conn.t, error :: WechatPay.Error.t, data :: map) :: any
end
