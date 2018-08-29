defmodule WechatPay.Config do
  alias WechatPay.Config

  @enforce_keys [:appid, :mch_id, :apikey]
  defstruct api_host: "https://api.mch.weixin.qq.com/",
            appid: nil,
            mch_id: nil,
            apikey: nil,
            ssl_cacert: nil,
            ssl_cert: nil,
            ssl_key: nil,
            verify_sign: false

  @type t :: %Config{
          api_host: String.t(),
          appid: String.t(),
          mch_id: String.t(),
          apikey: String.t(),
          ssl_cacert: String.t() | nil,
          ssl_cert: String.t(),
          ssl_key: String.t(),
          verify_sign: boolean
        }

  @doc "defines a config for WechatPay"
  @callback config :: Config.t()

  @doc """
  Build a new Config from keyword list
  """
  @spec new(Enum.t()) :: Config.t()
  def new(opts) do
    struct(Config, opts)
  end
end
