defmodule WechatPay.API.GetSandboxSignkeyTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias WechatPay.API.Client

  test "get the sandbox signkey" do
    use_cassette "get_sandbox_signkey" do
      {:ok, data} = Client.get_sandbox_signkey()

      assert data.sandbox_signkey
    end
  end
end

