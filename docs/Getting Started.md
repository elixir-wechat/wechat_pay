# Getting Started

## Installation

Simply add `wechat_pay` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:wechat_pay, "~> 0.2.0"}]
end
```

then run `mix deps.get` and you are ready to go.

## Setup

### Define your pay module

You need to define you own pay module, then `use` WechatPay, with an `:otp_app`
option.

```elixir
defmodule MyApp.Pay do
  use WechatPay, otp_app: :my_app
end
```

this will generate following modules for you:

- `MyApp.Pay.App`
- `MyApp.Pay.JSAPI`
- `MyApp.Pay.Native`

which are correspond to different payment scenario.

### Configuration

In your `config/config.exs`:

```elixir
config :my_app, MyApp.Pay,
  env: :production,
  appid: "the-appid",
  mch_id: "the-mch-id",
  apikey: "the-apikey",
  ssl_cacertfile: "fixture/certs/all.pem",
  ssl_certfile: "fixture/certs/apiclient_cert.pem",
  ssl_keyfile: "fixture/certs/apiclient_key.pem",
  ssl_password: ""
```

## Place an order

```elixir
case MyApp.Pay.Native.place_order(%{
  body: "Premuim Plan",
  out_trade_no: "xxx-xxxx-xxx",
  fee_type: "CNY",
  total_fee: 49000,
  spbill_create_ip: "127.0.0.1",
  notify_url: "http://example.com/notification"
  trade_type: "NATIVE",
  product_id: "zzz-xxxx-zzz"
}) do
  {:ok, order} ->
    # do something with the order
  {:error, error} ->
    # do something with error
end
```

