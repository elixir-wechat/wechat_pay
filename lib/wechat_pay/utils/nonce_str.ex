defmodule WechatPay.Utils.NonceStr do
  @moduledoc """
  Module to generate nonce string value
  """

  @doc """
  Generate a 32 length nonce string

  ## Example

  ```elixir
  iex> WechatPay.Utils.NonceStr.generate()
  ...> "dzhGXJ8zotL1LYkqnjnDSX9Cw0S2vV0"
  ```
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
