defmodule WechatPay.PaymentMethod.AppTest do
  use TestCase, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  test "generate pay request params required by the App SDK", %{config: config} do
    data = MyPay.App.generate_pay_request("wx20161011105257935386")

    assert data["appid"] == config.appid
    assert data["partnerid"] == config.mch_id
    assert data["prepayid"] == "wx20161011105257935386"
    assert data["package"] == "Sign=WXPay"
    assert data["noncestr"]
    assert data["timestamp"]
    assert data["sign"]
  end
end
