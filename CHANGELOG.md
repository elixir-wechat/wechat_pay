# CHANGELOG

## master

## v0.7.0

* Require Elixir >= 1.6
* Make the config `ssl_cacert` an optional option. (#11)

## v0.6.0

⚠️ Breaking changes

* Update dependency `:httpoison` to `~> 1.0`.
* Added new config option `:api_host`. Which make it possible to use oversea nodes such as *https://apihk.mch.weixin.qq.com/* and *https://apius.mch.weixin.qq.com/*. This also replace the `:env` config.
* Added a flexible configuration system to fit more usage senarios.

## v0.5.0

* Make JSON library an optional dependency,
  [Jason](https://github.com/michalmuskala/jason) is recommended.

## v0.4.1

* Fixes `:xmerl` is missing in the application list.

## v0.4.0

* Added `WechatPay.Plug.Refund` to handle refund notification from Wechat's Payment Gateway
* Parse XML with `:xmerl`, drop dependency on `sweet_xml`.

## v0.3.1

* Added task `mix wechat_pay.get_sandbox_signkey` to get the Sandbox API Key.
* Fixes wrong return value of `WechatPay.Helper.get_sandbox_signkey/2`.

## V0.3.0

⚠️ Breaking changes

### Guides

Guides are added on the [Online documentation](https://hexdocs.pm/wechat_pay).
I strongly recommend you to go through it aftre reading this changelog.

### You own implementation module

Now you have to define you own pay module, then `use` WechatPay,
with an `:otp_app` option.

```elixir
defmodule MyPay do
  use WechatPay, otp_app: :my_app
end
```

Then config with:

```elixir
config :my_app, MyPay,
  env: :production,
  appid: "wx8888888888888888",
  mch_id: "1900000109",
  apikey: "192006250b4c09247ec02edce69f6a2d",
  ssl_cacert: File.read!("fixture/certs/rootca.pem"),
  ssl_cert: File.read!("fixture/certs/apiclient_cert.pem"),
  ssl_key: File.read!("fixture/certs/apiclient_key.pem")
```

This change makes it possible to define multiple pay modules with their own
configuration.

### Separating payment methods

When `use` WechatPay in `MyPay` module, it will generate following
payment method modules for you:

* `MyPay.App`
* `MyPay.JSAPI`
* `MyPay.Native`

Each refers to a pay scenario of WechatPay.

### Handler

A new module `WechatPay.Handler` is added to assist processing the data from
Wechat's Payment Gateway.

Now the Plugs are only takes the responsibility to commutate with Wechat's
Payment Gateway, so you should passed in your own handler:

```elixir
post "/pay/cb/payment", MyPay.Plug.Payment, [handler: MyPaymentHandler]
```

and the handler implementation should looks like this:

```elixir
defmodule MyPaymentHandler do
  use WechatPay.Handler

  @impl WechatPay.Handler
  def handle_data(conn, data) do
    # do something with data
    :ok
  end

  # This is optional
  @impl WechatPay.Handler
  def handle_error(conn, error, data) do
    Logger.error(inspect(error))
  end
end
```

### Sandbox API Key

As the Sandbox API Key is requried to be fetched before configuring,
so the `WechatPay.API.get_sandbox_signkey/0` is moved to
`WechatPay.Helper.get_sandbox_signkey/2`, which accept `apikey` and `mch_id`
to generate the Sandbox API Key.

```elixir
iex> WechatPay.Helper.get_sandbox_signkey("wx8888888888888888", "1900000109")
...> {:ok, "the-key"}
```

### SSL configuration

The `ssl_cacertfile`, `ssl_certfile`, `ssl_keyfile` and `ssl_password`
configuration are removed.

Instead, the `ssl_cacert`, `ssl_cert` and `ssl_key` configuration is added, these
new configs accepts binary. Which make it possible to read these sensitive data
from an ENV.

```elixir
config :wechat_pay, MyPay,
  ssl_cacert: File.read!("fixture/certs/rootca.pem"),
  ssl_cert: File.read!("fixture/certs/apiclient_cert.pem"),
  ssl_key: "${MY_APP_WECHAT_PAY_SSL_KEY}"
```

### Other changes

* Added `MyPay.App.generate_pay_request/1` to generate pay request for App.

## v0.2.0

⚠️ Breaking changes

* Correctly handle malformed XML data.
* Added `WechatPay.Error`.
* Fixes warnings on Elixir 1.4.
* Added `WechatPay.API.get_sandbox_signkey/0` to get sandbox signkey.
* Rename `WechatPay.Plug.Notify` -> `WechatPay.Plug.Callback`, and rewrite the
  flow. Now it's easier to handle callbacks from Wehcat's Payment Gateway.
* Drop support for loading config from `{:system, ENV}`. It seems not a good
  idea to do this, consider https://github.com/bitwalker/conform.

## v0.1.1

* Fixes hexdocs.pm does not recognize upcase in URL.
* Improve docs.

## v0.1.0

* Initial support Wechat Pay's JSAPI, Native and App.
