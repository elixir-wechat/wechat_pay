defmodule WechatPay.API.QueryOrderTest do
  use TestCase, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias WechatPay.API

  test "query an order", %{config: config} do
    use_cassette "query_order" do
      {:ok, data} = API.query_order(%{out_trade_no: "xxx"}, config)

      assert data.return_msg == "OK"
    end
  end
end
