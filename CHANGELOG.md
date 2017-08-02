# master

⚠️ Breaking changes

## You own implementation module

Now you need to define you own pay module, then `use` WechatPay,
with an `:otp_app` option.

```elixir
defmodule MyApp.Pay do
  use WechatPay, otp_app: :my_app
end
```

Then config with:

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

this makes WechatPay works well with umbrella apps.

When `use` WechatPay in `MyApp.Pay` module, it will generate following
payment method modules for you:

- `MyApp.Pay.App`
- `MyApp.Pay.JSAPI`
- `MyApp.Pay.Native`

## Handler

Now the plugs are only takes the responsibility to commutate with Wechat's
Payment Gateway, then you should implement your own `WechatPay.Handler` to
process the result.

```elixir
post "/pay/cb/payment", MyApp.Pay.Plug.Payment, [handler: MyApp.PaymentHandler]
```

```elixir
defmodule MyApp.WechatHandler do
  use WechatPay.Handler

  @impl WechatPay.Handler
  def handle_data(conn, data) do
    :ok
  end

  # This is optional
  @impl WechatPay.Handler
  def handle_error(conn, error, data) do
  end
end
```

## Others

* `WechatPay.API.get_sandbox_signkey/0` => `WechatPay.Helper.get_sandbox_signkey/2`.

# v0.2.0

⚠️ Breaking changes

* Correctly handle malformed XML data.
* Added `WechatPay.Error`.
* Fixes warnings on Elixir 1.4.
* Added `WechatPay.API.get_sandbox_signkey/0` to get sandbox signkey.
* Rename `WechatPay.Plug.Notify` -> `WechatPay.Plug.Callback`, and rewrite the
  flow. Now it's easier to handle callbacks from Wehcat's Payment Gateway.
* Drop support for loading config from `{:system, ENV}`. It seems not a good
  idea to do this, consider https://github.com/bitwalker/conform.

# v0.1.1

* Fixes hexdocs.pm does not recognize upcase in URL.
* Improve docs.

# v0.1.0

* Initial support Wechat Pay's JSAPI, Native and App.
