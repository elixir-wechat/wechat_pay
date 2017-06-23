defmodule WechatPay.Native do
  @moduledoc """
  Module for the *Native* payment method

  [API document](https://pay.weixin.qq.com/wiki/doc/api/native.php?chapter=9_1)
  """

  alias WechatPay.API
  alias WechatPay.API.Client

  defdelegate place_order(attrs), to: API

  defdelegate query_order(attrs), to: API

  defdelegate close_order(attrs), to: API

  defdelegate refund(attrs, opts), to: API

  defdelegate query_refund(attrs), to: API

  defdelegate download_bill(attrs), to: API

  defdelegate report(attrs), to: API

  @doc """
  Shorten the URL

  ## Examples

      iex> WechatPay.Native.shorten_url("weixin://wxpay/bizpayurl?sign=XXXXX&appid=XXXXX&mch_id=XXXXX&product_id=XXXXXX&time_stamp=XXXXXX&nonce_str=XXXXX")
      ...> {:ok, url}
  """
  @spec shorten_url(String.t) :: {:ok, String.t} | {:error, WechatPay.Error.t | HTTPoison.Error.t}
  def shorten_url(url) do
    Client.post("tools/shorturl", %{long_url: URI.encode(url)})
  end
end
