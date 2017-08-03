defmodule WechatPay.JSAPITest do
  use TestCase, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  test "generate params needed by the Wechat H5 API" do
    data = MyPay.JSAPI.generate_pay_request("wx20161011105257935386")

    assert data["package"] == "prepay_id=wx20161011105257935386"
  end
end
