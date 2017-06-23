defmodule WechatPay.API.CloseOrderTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias WechatPay.API

  test "close an order" do
    use_cassette "close_order" do
      {:ok, data} = API.close_order(%{out_trade_no: "xxx"})

      assert data.return_msg == "OK"
    end
  end
end
