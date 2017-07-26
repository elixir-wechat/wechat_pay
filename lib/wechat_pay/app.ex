defmodule WechatPay.App do
  @moduledoc """
  Module for the *App* payment method.

  [API document](https://pay.weixin.qq.com/wiki/doc/api/app/app.php?chapter=9_1)
  """

  alias WechatPay.API

  defdelegate place_order(attrs), to: API

  defdelegate query_order(attrs), to: API

  defdelegate close_order(attrs), to: API

  defdelegate refund(attrs), to: API

  defdelegate query_refund(attrs), to: API

  defdelegate download_bill(attrs), to: API

  defdelegate report(attrs), to: API
end
