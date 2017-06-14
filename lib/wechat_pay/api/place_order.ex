defmodule WechatPay.API.PlaceOrder do
  @moduledoc """
  Place Order API
  """

  alias WechatPay.API.Client

  @api_path "pay/unifiedorder"

  @doc """
  Call the `#{@api_path}` API

  ## Examples

      iex> WechatPay.API.PlaceOrder.request({
        device_info: "WEB",
        body: "Wechat-666",
        attach: nil,
        out_trade_no: "1415757673",
        fee_type: "CNY",
        total_fee: 709,
        spbill_create_ip: "127.0.0.1",
        notify_url: "http://example.com/wechat-pay-callback",
        time_start: 20091225091010,
        time_expire: 20091227091010,
        trade_type: "JSAPI",
        openid: "oUpF8uMuAJO_M2pxb1Q9zNjWeS6o",
      })
      {:ok, data}
  """
  @spec request(map) :: {:ok, map} | {:error, WechatPay.Error.t | HTTPoison.Error.t}
  def request(params \\ %{}) do
    order =
      WechatPay.API.PlaceOrder.Order
      |> struct(params)

    Client.post(@api_path, order)
  end

  defmodule Order do
    @moduledoc false

    @enforce_keys ~w(body out_trade_no total_fee spbill_create_ip notify_url trade_type)a
    defstruct [
      device_info: nil,
      body: nil,
      detail: nil,
      attach: nil,
      out_trade_no: nil,
      fee_type: "CNY",
      total_fee: nil,
      spbill_create_ip: nil,
      time_start: nil,
      time_expire: nil,
      goods_tag: nil,
      notify_url: nil,
      trade_type: nil,
      product_id: nil,
      limit_pay: nil,
      openid: nil,
    ]
  end
end
