defmodule WechatPay.Config do
  alias WechatPay.Config

  @enforce_keys [:env, :appid, :mch_id, :apikey]
  defstruct [:env, :appid, :mch_id, :apikey, :ssl_cacert, :ssl_cert, :ssl_key, verify_sign: false]

  @type t :: %Config{
          env: :sandbox | :production,
          appid: String.t(),
          mch_id: String.t(),
          apikey: String.t(),
          ssl_cacert: String.t(),
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
