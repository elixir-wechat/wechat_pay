defmodule WechatPay.API.HelperTest do
  use TestCase, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias WechatPay.Helper

  test "get the sandbox signkey", %{config: config} do
    use_cassette "get_sandbox_signkey" do
      apikey = Keyword.get(config, :apikey)
      mch_id = Keyword.get(config, :mch_id)

      {:ok, data} = Helper.get_sandbox_signkey(apikey, mch_id)

      assert data.sandbox_signkey
    end
  end
end

