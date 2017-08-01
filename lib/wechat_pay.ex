defmodule WechatPay do
  @moduledoc """
  WechatPay provide toolkit for the Wechat Payment Platform.

  When `use` WechatPay, you'll need an implementation module.

  ```elixir
  defmodule MyApp.Pay do
    use WechatPay, otp_app: :my_app
  end
  ```

  the `:otp_app` option is required.

  This will generate four modules:

  - `MyApp.Pay.App` - [App payment method](https://pay.weixin.qq.com/wiki/doc/api/app/app.php?chapter=8_1)
  - `MyApp.Pay.JSAPI` - [JSAPI payment method](https://pay.weixin.qq.com/wiki/doc/api/jsapi.php?chapter=7_1)
  - `MyApp.Pay.Native` - [Native payment method](https://pay.weixin.qq.com/wiki/doc/api/native.php?chapter=6_1)
  - `MyApp.Pay.Plug` - Handle callback from Wechat's server
  """

  @typedoc """
  The Configuration

  - `env` - `:sandbox` or `:production`
  - `appid` - APP ID
  - `mch_id` - Merchant ID
  - `apikey` - API key
  - `ssl_cacertfile` - CA certficate file path
  - `ssl_certfile` - Certificate file path
  - `ssl_keyfile` - Private key file path
  - `ssl_password` - Password for the private key
  """
  @type config :: [
    env: :sandbox | :production,
    appid: String.t,
    mch_id: String.t,
    apikey: String.t,
    ssl_cacertfile: String.t,
    ssl_certfile: String.t,
    ssl_keyfile: String.t,
    ssl_password: String.t
  ]

  defmacro __using__(opts) do
    quote bind_quoted: [opts: opts] do
      otp_app = Keyword.fetch!(opts, :otp_app)

      @spec get_config :: WechatPay.config
      def get_config do
        __MODULE__
        |> WechatPay.build_config(unquote(otp_app))
      end

      # define module `MyModule.App`
      __MODULE__
      |> Module.concat(:App)
      |> Module.create(
        quote do
          use WechatPay.PaymentMethod.App, mod: unquote(__MODULE__)
        end,
        Macro.Env.location(__ENV__)
      )

      # define module `MyModule.JSAPI`
      __MODULE__
      |> Module.concat(:JSAPI)
      |> Module.create(
        quote do
          use WechatPay.PaymentMethod.JSAPI, mod: unquote(__MODULE__)
        end,
        Macro.Env.location(__ENV__)
      )

      # define module `MyModule.Native`
      __MODULE__
      |> Module.concat(:Native)
      |> Module.create(
        quote do
          use WechatPay.PaymentMethod.Native, mod: unquote(__MODULE__)
        end,
        Macro.Env.location(__ENV__)
      )

      # define module `MyModule.Plug`
      if Code.ensure_loaded?(Plug) do
        __MODULE__
        |> Module.concat(:Plug)
        |> Module.create(
          quote do
            use WechatPay.Plug, mod: unquote(__MODULE__)
          end,
          Macro.Env.location(__ENV__)
        )
      end
    end
  end

  @doc false
  def build_config(module, otp_app) do
    otp_app
    |> Application.fetch_env!(module)
  end
end
