defmodule WechatPay.API.PlaceOrderTest do
  use TestCase, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias WechatPay.API

  test "place an order", %{client: client} do
    params = %{
      body: "foobar",
      out_trade_no: "xxx",
      total_fee: 100,
      spbill_create_ip: "192.168.1.1",
      notify_url: "http://example.com",
      trade_type: "JSAPI",
      openid: "foobar",
      detail: %{}
    }

    use_cassette "place_order" do
      {:ok, data} = API.place_order(client, params)

      assert data.trade_type == "JSAPI"
      assert data.prepay_id
      assert data.code_url =~ ~R(^weixin://wxpay)
    end
  end
end
