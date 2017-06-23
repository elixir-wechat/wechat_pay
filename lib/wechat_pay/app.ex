defmodule WechatPay.App do
  alias WechatPay.API

  defdelegate place_order(attrs), to: API

  defdelegate query_order(attrs), to: API

  defdelegate close_order(attrs), to: API

  defdelegate refund(attrs, opts), to: API

  defdelegate query_refund(attrs), to: API

  defdelegate download_bill(attrs), to: API

  defdelegate report(attrs), to: API
end
