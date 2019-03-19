defmodule WechatPay do
  @moduledoc """
  WechatPay provide toolkit for Wechat Payment Platform.

  ### Setup

  Currently, WechatPay has three main modules:

  * `WechatPay.App`
  * `WechatPay.JSAPI`
  * `WechatPay.Native`

  client = WechatPay.App.new(

  )
  %WechatPay.App{
    app_id: "the-app_id",
    mch_id: "the-mch-id",
    api_key: "the-api_key",
    ssl_cacert: File.read!("fixture/certs/rootca.pem"),
    ssl_cert: File.read!("fixture/certs/apiclient_cert.pem"),
    ssl_key: File.read!("fixture/certs/apiclient_key.pem")
  }

  WechatPay.App.close_order(client, attrs)


  ```elixir
  defmodule MyPay do
    use WechatPay, otp_app: :my_app
  end
  ```

  Then config your app in `config/config.exs`:

  ```elixir
  config :my_app, MyPay,
    app_id: "the-app_id",
    mch_id: "the-mch-id",
    api_key: "the-api_key",
    ssl_cacert: File.read!("fixture/certs/rootca.pem"),
    ssl_cert: File.read!("fixture/certs/apiclient_cert.pem"),
    ssl_key: File.read!("fixture/certs/apiclient_key.pem")
  ```

  If this does not fit your needs, you might want to check [Configuration](configuration.html).

  > NOTE: WechatPay provide `Mix.Tasks.WechatPay.GetSandboxSignkey` to
  > fetch the Sandbox API Key.

  ### Payment methods

  When `use` WechatPay in `MyPay` module, it will generate following
  modules for you:

  - `MyPay.App` - Implements the `WechatPay.App.Behaviour` behaviour
  - `MyPay.JSAPI` - Implements the `WechatPay.JSAPI.Behaviour` behaviour
  - `MyPay.Native` - Implements the `WechatPay.Native.Behaviour` behaviour

  ### Plug

  WechatPay will also generate some [Plugs](https://github.com/elixir-plug/plug) to
  simplify the process of handling notification from Wechat's Payment Gateway:

  - `MyPay.Plug.Payment` - Implements the `WechatPay.Plug.Payment` behaviour
  - `MyPay.Plug.Refund` - Implements the `WechatPay.Plug.Refund` behaviour

  ### JSON Encoder

  By default, `WechatPay` use `Jason` to encode JSON, if you want to use `Poison`,
  you can configure `:wechat_pay` application with:

  ```elixir
  config :wechat_pay, :json_library, Poison
  ```
  """
end
