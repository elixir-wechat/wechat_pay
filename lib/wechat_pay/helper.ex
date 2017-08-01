defmodule WechatPay.Helper do
  @moduledoc """
  Collection of helper functions
  """

  alias WechatPay.API.Client

  defdelegate get_sandbox_signkey(apikey, mch_id), to: Client
end
