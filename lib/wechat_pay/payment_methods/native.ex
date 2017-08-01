defmodule WechatPay.PaymentMethod.Native do
  @moduledoc """
  Module for the *Native* payment method

  [API document](https://pay.weixin.qq.com/wiki/doc/api/native.php?chapter=9_1)
  """

  alias WechatPay.API
  alias WechatPay.API.Client

  defmacro __using__(opts) do
    quote bind_quoted: [opts: opts] do
      mod = Keyword.fetch!(opts, :mod)

      defdelegate get_config, to: mod

      def place_order(attrs),
        do: API.place_order(attrs, get_config())

      def query_order(attrs),
        do: API.query_order(attrs, get_config())

      def close_order(attrs),
        do: API.close_order(attrs, get_config())

      def refund(attrs),
        do: API.refund(attrs, get_config())

      def query_refund(attrs),
        do: API.query_refund(attrs, get_config())

      def download_bill(attrs),
        do: API.download_bill(attrs, get_config())

      def report(attrs),
        do: API.report(attrs, get_config())

      @doc """
      Shorten the URL

      ## Examples

      iex> WechatPay.Native.shorten_url("weixin://wxpay/bizpayurl?sign=XXXXX&appid=XXXXX&mch_id=XXXXX&product_id=XXXXXX&time_stamp=XXXXXX&nonce_str=XXXXX")
      ...> {:ok, url}
      """
      @spec shorten_url(String.t) :: {:ok, String.t} | {:error, WechatPay.Error.t | HTTPoison.Error.t}
      def shorten_url(url) do
        Client.post("tools/shorturl", %{long_url: URI.encode(url)}, [], get_config())
      end
    end
  end
end
