# Using with Phoenix

## Setup

WechatPay also provide [Plugs](https://github.com/elixir-plug/plug)
to assist you handling notification from Wechat's Payment Gateway:

- `WechatPay.Plug.Payment`
- `WechatPay.Plug.Refund`

## Usage

We use `WechatPay.Plug.Payment` as an example:

### Define a handler

```elixir
defmodule MyApp.WechatHandler do
  use WechatPay.Plug.Handler

  @impl WechatPay.Plug.Handler
  def handle_data(conn, data) do
    # do something with the data.
    # the sign is already verified with `WechatPay.Utils.Signature.verify/3`.
    %{appid: appid} = data

    # return `:ok` to tell wechat server that you have successfully handled this notification.
    :ok
  end

  # This is optional
  @impl WechatPay.Plug.Handler
  def handle_error(conn, error, data) do
    # do something with the error or data
  end
end
```

### Plug in

In your app's `lib/my_app_web/router.ex`:

```elixir
post "/pay/cb/payment", WechatPay.Plug.Payment, [handler: MyApp.WechatHandler, api_key: "my-api-key"]
```

### Placing order

When you are placing an order, you should set the `notify_url` as this endpoint.

```elixir
case MyPay.Native.place_order(%{
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
