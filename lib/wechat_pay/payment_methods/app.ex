defmodule WechatPay.PaymentMethod.App do
  @moduledoc """
  Module for the *App* payment method.

  [API document](https://pay.weixin.qq.com/wiki/doc/api/app/app.php?chapter=9_1)

  When `use` this module
  """

  alias WechatPay.API

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
    end
  end
end
