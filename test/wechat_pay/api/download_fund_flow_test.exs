defmodule WechatPay.API.DownloadFundFlowTest do
  use TestCase, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias WechatPay.API

  test "download fund flow", %{client: client} do
    use_cassette "download_fund_flow" do
      params = %{
        bill_date: "20140603",
        account_type: "Basic"
      }

      {:ok, data} = API.download_fund_flow(client, params)

      assert data =~ ~r/记账时间/
    end
  end
end
