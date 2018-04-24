defmodule WechatPay.Behaviour do
  @moduledoc """
  The WechatPay behaviour
  """

  @doc "defines a config for WechatPay"
  @callback config :: config_t()

  @typedoc """
  The Configuration

  - `env` - `:sandbox` or `:production`
  - `appid` - APP ID
  - `mch_id` - Merchant ID
  - `apikey` - API key
  - `ssl_cacert` - CA Root certificate in PEM
  - `ssl_cert` - Certificate in PEM
  - `ssl_key` - Private key in PEM
  """
  @type config_t :: [
          env: :sandbox | :production,
          appid: String.t(),
          mch_id: String.t(),
          apikey: String.t(),
          ssl_cacert: String.t(),
          ssl_cert: String.t(),
          ssl_key: String.t()
        ]
end
