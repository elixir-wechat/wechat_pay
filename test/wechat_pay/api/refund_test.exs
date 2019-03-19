defmodule WechatPay.API.RefundTest do
  use TestCase, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias WechatPay.API

  test "refund", %{client: client} do
    use_cassette "refund" do
      params = %{
        device_info: "013467007045764",
        transaction_id: "1217752501201407033233368018",
        out_trade_no: "1217752501201407033233368018",
        out_refund_no: "1217752501201407033233368018",
        total_fee: 100,
        refund_fee: 100,
        refund_fee_type: "CNY",
        op_user_id: "1900000109",
        refund_account: "REFUND_SOURCE_RECHARGE_FUNDS"
      }

      {:ok, data} = API.refund(client, params)

      assert data.return_msg == "OK"
    end
  end
end
