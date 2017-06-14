defmodule WechatPay.API.ShortenURL do
  @moduledoc """
  Shorten URL
  """

  alias WechatPay.API.Client

  @api_path "tools/shorturl"

  @doc """
  Call the `#{@api_path}` API

  ## Examples

      iex> WechatPay.API.ShortenURL.request("weixin://wxpay/bizpayurl?sign=XXXXX&appid=XXXXX&mch_id=XXXXX&product_id=XXXXXX&time_stamp=XXXXXX&nonce_str=XXXXX")
      {:ok, url}
  """
  @spec request(String.t) :: {:ok, String.t} | {:error, WechatPay.Error.t | HTTPoison.Error.t}
  def request(url) do
    Client.post(@api_path, %{long_url: URI.encode(url)})
  end
end
