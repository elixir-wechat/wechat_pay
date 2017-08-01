defmodule WechatPay.API.CloseOrderTest do
  use TestCase, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias WechatPay.API

  test "close an order", %{config: config} do
    use_cassette "close_order" do
      {:ok, data} = API.close_order(%{out_trade_no: "xxx"}, config)

      assert data.return_msg == "OK"
    end
  end
end
