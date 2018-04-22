# Using with Phoenix

## Setup

WechatPay also generate some [Plugs](https://github.com/elixir-plug/plug) to
  simplify the process of handling notification from Wechat's Payment Gateway

If you are using WechatPay in a phoenix App,
when you `use` WechatPay in your module:

```elixir
defmodule MyApp.Pay do
  use WechatPay, otp_app: :my_app
end
```

The following modules are also generated for you:

- `MyApp.Pay.Plug.Payment` - Implements `WechatPay.Plug.Payment`
- `MyApp.Pay.Plug.Refund` - Implements `WechatPay.Plug.Refund`

## Usage

We use `MyApp.Pay.Plug.Payment` as an example:

### Implement the handler

```elixir
defmodule MyApp.WechatHandler do
  use WechatPay.Handler

  @impl WechatPay.Handler
  def handle_data(conn, data) do
    # do something with the data. 
    # the sign is already verified. if you want, you can verify again use `WechatPay.Utils.Signature.verify/2`. 
    # return `:ok` to tell wechat server that you have successfully handled this notification.
    :ok
  end

  # This is optional
  @impl WechatPay.Handler
  def handle_error(conn, error, data) do
    # do something with the error or data
  end
end
```

### Plug in

In your app's `lib/my_app_web/router.ex`:

```elixir
post "/pay/cb/payment", MyApp.Pay.Plug.Payment, [handler: MyApp.WechatHandler]
```

### Placing order

When you are placing an order, you should set the `noficy_url` as this endpoint.

```elixir
case MyApp.Pay.Native.place_order(%{
  body: "Premuim Plan",
  out_trade_no: "xxx-xxxx-xxx",
  fee_type: "CNY",
  total_fee: 49000,
  spbill_create_ip: "127.0.0.1",
  notify_url: "http://your-domain.net/pay/cb/payment"
  trade_type: "NATIVE",
  product_id: "zzz-xxxx-zzz"
}) do
  {:ok, order} ->
    # do something with the order
  {:error, error} ->
    # do something with error
end
```
