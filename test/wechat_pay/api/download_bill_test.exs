defmodule WechatPay.API.DownloadBillTest do
  use TestCase, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias WechatPay.API

  test "download bills", %{config: config} do
    use_cassette "download_bill" do
      params = %{
        device_info: "013467007045764",
        bill_date: "20140603",
        bill_type: "ALL"
      }

      {:ok, data} = API.download_bill(params, config)

      assert data =~ ~r/公众账号ID/
    end
  end
end
