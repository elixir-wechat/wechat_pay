defmodule WechatPay.AppTest do
  use TestCase, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  test "generate pay request params required by the App SDK", %{client: client} do
    data = WechatPay.App.generate_pay_request(client, "wx20161011105257935386")

    assert data["appid"] == client.app_id
    assert data["partnerid"] == client.mch_id
    assert data["prepayid"] == "wx20161011105257935386"
    assert data["package"] == "Sign=WXPay"
    assert data["noncestr"]
    assert data["timestamp"]
    assert data["sign"]
  end
end
