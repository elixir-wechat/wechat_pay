# Getting Started

## Installation

Simply add `wechat_pay` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:wechat_pay, "~> 0.7.0"},
    {:jason, "~> 1.0"} # or {:poison, "~> 4.0"}
  ]
end
```

then run `mix deps.get` and you are ready to go.

## Setup

### Define your pay module

You need to define you own pay module, then `use` `WechatPay`.

```elixir
defmodule MyPay do
  use WechatPay, otp_app: :my_app
end
```

the following modules will be generated for you:

* `MyPay.App`
* `MyPay.JSAPI`
* `MyPay.Native`

which are corresponding to different payment scenario.

### Configuration

In your `config/config.exs`:

```elixir
config :my_app, MyPay,
  appid: "the-appid",
  mch_id: "the-mch-id",
  apikey: "the-apikey",
  ssl_cacert: File.read!("fixture/certs/rootca.pem"),
  ssl_cert: File.read!("fixture/certs/apiclient_cert.pem"),
  ssl_key: File.read!("fixture/certs/apiclient_key.pem")
```

## Place an order

```elixir
case MyPay.Native.place_order(%{
  body: "Premium Plan",
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

## Phoenix

See the [Phoenix doc](phoenix.html)

## More

For a detailed usage, please see the module doc for `WechatPay`.
