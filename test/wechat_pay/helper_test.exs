defmodule WechatPay.API.HelperTest do
  use TestCase, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias WechatPay.Helper

  test "get the sandbox signkey", %{config: config} do
    use_cassette "get_sandbox_signkey" do
      apikey = Keyword.get(config, :apikey)
      mch_id = Keyword.get(config, :mch_id)

      {:ok, sandbox_signkey} = Helper.get_sandbox_signkey(apikey, mch_id)

      assert sandbox_signkey == "bd1c50c287f1f5d4c9bd602c4fba6f8a"
    end
  end
end

