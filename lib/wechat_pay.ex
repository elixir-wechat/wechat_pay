defmodule WechatPay do
  @moduledoc """
  WechatPay provide toolkit for Wechat Payment Platform.

  ## Core

  Currently, WechatPay has the following Pay modules:

  * `WechatPay.App`
  * `WechatPay.JSAPI`
  * `WechatPay.Native`

  ## Plug

  The following [Plugs](https://github.com/elixir-plug/plug) are also provided
  to assist you handling notification from Wechat's Payment Gateway:

  - `WechatPay.Plug.Payment`
  - `WechatPay.Plug.Refund`

  ## JSON Encoder

  By default, `WechatPay` use `Jason` to encode JSON, if you want to use `Poison`,
  you can configure `:wechat_pay` application with:

  ```elixir
  config :wechat_pay, :json_library, Poison
  ```
  """
end
