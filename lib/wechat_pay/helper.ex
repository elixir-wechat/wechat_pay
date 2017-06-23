defmodule WechatPay.Helper do
  @moduledoc """
  Collection of helper functions
  """

  alias WechatPay.API.Client

  defdelegate get_sandbox_signkey, to: Client
end
