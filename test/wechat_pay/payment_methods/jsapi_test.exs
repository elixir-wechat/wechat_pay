defmodule WechatPay.JSAPITest do
  use TestCase, async: false

  test "generate pay request params required by the JavaScript API", %{client: client} do
    data = WechatPay.JSAPI.generate_pay_request(client, "wx20161011105257935386")

    assert data["package"] == "prepay_id=wx20161011105257935386"
  end
end
