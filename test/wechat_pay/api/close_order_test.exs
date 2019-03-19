defmodule WechatPay.API.CloseOrderTest do
  use TestCase, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias WechatPay.API

  test "close an order", %{client: client} do
    use_cassette "close_order" do
      {:ok, data} = API.close_order(client, %{out_trade_no: "xxx"})

      assert data.return_msg == "OK"
    end
  end
end
