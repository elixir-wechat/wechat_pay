defmodule WechatPay.Utils.NonceStr do
  @moduledoc """
  Module to generate nonce string value
  """

  @doc """
  Generate a nonce string
  """
  @spec generate() :: String.t
  def generate do
    length = 31

    length
    |> :crypto.strong_rand_bytes()
    |> Base.url_encode64
    |> binary_part(0, length)
  end
end
