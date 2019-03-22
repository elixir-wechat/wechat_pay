defmodule WechatPay.API.HelperTest do
  use TestCase, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias WechatPay.Helper

  test "get the sandbox signkey", %{client: client} do
    use_cassette "get_sandbox_signkey" do
      api_key = client.api_key
      mch_id = client.mch_id

      {:ok, result} = Helper.get_sandbox_signkey(api_key, mch_id)

      assert result.sandbox_signkey == "bd1c50c287f1f5d4c9bd602c4fba6f8a"
    end
  end
end
