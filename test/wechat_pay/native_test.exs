defmodule WechatPay.NativeTest do
  use TestCase, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  test "shorten an url" do
    use_cassette "shorten_url" do
      {:ok, data} = MyPay.Native.shorten_url("weixin://wxpay/bizpayurl?sign=XXXXX&appid=XXXXX&mch_id=XXXXX&product_id=XXXXXX&time_stamp=XXXXXX&nonce_str=XXXXX")

      assert data.return_msg == "OK"
      assert data.short_url == "weixin://wxpay/bizpayurl?pr=I1kiguB"
    end
  end
end
