defmodule WechatPay.API.RefundTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias WechatPay.API

  test "refund" do
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

      opts = [
        hackney: [
          ssl_options: [
            cacertfile: "fixture/certs/all.pem",
            certfile: "fixture/certs/apiclient_cert.pem",
            keyfile: "fixture/certs/apiclient_key.pem",
            password: ""
          ]
        ]
      ]

      {:ok, data} = API.refund(params, opts)

      assert data.return_msg == "OK"
    end
  end
end
