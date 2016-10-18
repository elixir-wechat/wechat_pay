defmodule WechatPay.API.DownloadBillTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias WechatPay.API.DownloadBill

  test "download bills" do
    use_cassette "download_bill" do
      {:ok, data} = DownloadBill.request(device_info: "013467007045764", bill_date: "20140603", bill_type: "ALL")

      assert data =~ ~r/公众账号ID/
    end
  end
end
