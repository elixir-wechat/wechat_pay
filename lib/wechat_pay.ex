defmodule WechatPay do
  @moduledoc """
  WechatPay provide toolkit for the Wechat Payment Platform.

  ### Setup

  You need to define you own pay module, then `use` WechatPay, with an `:otp_app`
  option.

  ```elixir
  defmodule MyApp.Pay do
    use WechatPay, otp_app: :my_app
  end
  ```

  Then you can config your app with:

  ```elixir
  config :my_app, MyApp.Pay,
    env: :production,
    appid: "wx8888888888888888",
    mch_id: "1900000109",
    apikey: "192006250b4c09247ec02edce69f6a2d",
    ssl_cacertfile: "fixture/certs/all.pem",
    ssl_certfile: "fixture/certs/apiclient_cert.pem",
    ssl_keyfile: "fixture/certs/apiclient_key.pem",
    ssl_password: ""
  ```

  > NOTE: If your are using the `:sandbox` environment,
  > You need to use `WechatPay.Helper.get_sandbox_signkey/2` to
  > fetch the Sandbox API Key.
  > where the `apikey` and `mch_id` is the production one.

  ### Usage

  When `use` WechatPay in `MyApp.Pay` module, it will generate following modules
  for you:

  - `MyApp.Pay.App` - Implements the `WechatPay.PaymentMethod.App` Behaviour
  - `MyApp.Pay.JSAPI` - Implements the `WechatPay.PaymentMethod.JSAPI` Behaviour
  - `MyApp.Pay.Native` - Implements the `WechatPay.PaymentMethod.Native` Behaviour
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

      @doc false
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
