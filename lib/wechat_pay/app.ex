defmodule WechatPay.App do
  @moduledoc """
  Module for the *App* payment method.

  [API document](https://pay.weixin.qq.com/wiki/doc/api/app/app.php?chapter=9_1)
  """

  alias WechatPay.API

  defdelegate place_order(attrs, opts \\ []), to: API

  defdelegate query_order(attrs, opts \\ []), to: API

  defdelegate close_order(attrs, opts \\ []), to: API

  defdelegate refund(attrs, opts \\ []), to: API

  defdelegate query_refund(attrs, opts \\ []), to: API

  defdelegate download_bill(attrs, opts \\ []), to: API

  defdelegate report(attrs, opts \\ []), to: API
end
