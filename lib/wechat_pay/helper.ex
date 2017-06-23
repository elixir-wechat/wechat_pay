defmodule WechatPay.Helper do
  alias WechatPay.API.Client

  defdelegate get_sandbox_signkey, to: Client
end
