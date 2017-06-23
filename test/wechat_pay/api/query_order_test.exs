defmodule WechatPay.API.QueryOrderTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias WechatPay.API

  test "query an order" do
    use_cassette "query_order" do
      {:ok, data} = API.query_order(%{out_trade_no: "xxx"})

      assert data.return_msg == "OK"
    end
  end
end
