defmodule WechatPay.Utils.NonceStr do
  @moduledoc false

  @doc """
  Generate a nonce string
  """
  def generate do
    length = 31

    length
    |> :crypto.strong_rand_bytes()
    |> Base.url_encode64
    |> binary_part(0, length)
  end
end
