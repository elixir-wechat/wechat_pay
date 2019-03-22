defmodule WechatPay.API.QueryRefundTest do
  use TestCase, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias WechatPay.API

  test "query refund", %{client: client} do
    use_cassette "query_refund" do
      params = %{
        device_info: "013467007045764",
        out_trade_no: "1415757673"
      }

      {:ok, data} = API.query_refund(client, params)

      assert data.return_msg == "OK"
    end
  end
end
