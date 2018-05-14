defmodule WechatPay.JSAPITest do
  use TestCase, async: false

  test "generate pay request params required by the JavaScript API" do
    data = MyPay.JSAPI.generate_pay_request("wx20161011105257935386")

    assert data["package"] == "prepay_id=wx20161011105257935386"
  end
end
