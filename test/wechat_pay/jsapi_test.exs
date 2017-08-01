defmodule WechatPay.JSAPITest do
  use ExUnit.Case, async: false

  test "generate params needed by the Wechat H5 API" do
    data = WechatPay.JSAPI.generate_pay_request("wx20161011105257935386")

    assert data["package"] == "prepay_id=wx20161011105257935386"
  end
end
