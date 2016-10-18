# WechatPay

WechatPay API wrapper in Elixir.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add `wechat_pay` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:wechat_pay, "~> 0.1.0"}]
    end
    ```

  2. Ensure `wechat_pay` is started before your application:

    ```elixir
    def application do
      [applications: [:wechat_pay]]
    end
    ```

## Usage

### Config `:wechat_pay`

```elixir
use Mix.Config

config :wechat_pay,
  env: :sandbox,
  appid: "wx8888888888888888",
  mch_id: "1900000109",
  apikey: "192006250b4c09247ec02edce69f6a2d",
  ssl_cacertfile: "certs/ca.cert",
  ssl_certfile: "certs/client.crt",
  ssl_keyfile: "certs/client.key",
  ssl_password: "test"
```

Or in production

```elixir
use Mix.Config

config :wechat_pay,
  env: :production,
  appid: {:system, "WECHAT_PAY_APP_ID"},
  mch_id: {:system, "WECHAT_PAY_MCH_ID"},
  apikey: {:system, "WECHAT_PAY_API_KEY"},
  ssl_cacertfile: {:system, "WECHAT_PAY_SSL_CA_CERTFILE"},
  ssl_certfile: {:system, "WECHAT_PAY_SSL_CERTFILE"},
  ssl_keyfile: {:system, "WECHAT_PAY_SSL_KEYFILE"},
  ssl_password: {:system, "WECHAT_PAY_SSL_PASSWORD"}
```

### APIs

[https://pay.weixin.qq.com/wiki/doc/api/index.html](https://pay.weixin.qq.com/wiki/doc/api/index.html)

#### JSAPI（公众号支付）

- [x] `WechatPay.API.place_order(params)`
- [x] `WechatPay.API.query_order(params)`
- [x] `WechatPay.API.close_order(params)`
- [x] `WechatPay.API.refund(params)`
- [x] `WechatPay.API.query_refund(params)`
- [x] `WechatPay.API.download_bill(params)`
- [x] `WechatPay.API.report(params)`
- [x] `WechatPay.HTML.generate_pay_request(prepay_id)`

#### Native（扫码支付）

- [x] `WechatPay.API.place_order(params)`
- [x] `WechatPay.API.query_order(params)`
- [x] `WechatPay.API.close_order(params)`
- [x] `WechatPay.API.refund(params)`
- [x] `WechatPay.API.query_refund(params)`
- [x] `WechatPay.API.download_bill(params)`
- [x] `WechatPay.API.report(params)`
- [x] `WechatPay.API.shorten_url(url)`

#### APP（APP支付）

- [x] `WechatPay.API.place_order(params)`
- [x] `WechatPay.API.query_order(params)`
- [x] `WechatPay.API.close_order(params)`
- [x] `WechatPay.API.refund(params)`
- [x] `WechatPay.API.query_refund(params)`
- [x] `WechatPay.API.report(params)`
- [x] `WechatPay.API.download_bill(params)`

#### Example

```elixir
params = %{
  device_info: "WEB",
  body: "时习-#{event.title}",
  attach: nil,
  out_trade_no: order.order_number,
  fee_type: "CNY",
  total_fee: order.fee,
  spbill_create_ip: Keyword.get(opts, :remote_ip),
  notify_url: @notify_url,
  time_start: now |> format_datetime,
  time_expire: now |> Timex.shift(hours: 1) |> format_datetime,
  trade_type: "JSAPI",
  openid: User.openid(user),
}

case WechatPay.place_order(params) do
  {:ok, order} ->
    order
  {:error, reason} ->
    IO.inspect reason
end
```

### Handle callback

```elixir
# Will call the handle_success/2 function on your handler
plug WechatPay.Plug.Notify, handler: MyHandler

# Will call the some_fun/2 function on your handler
plug WechatPay.Plug.Notify, handler: {MyHandler, :some_fun}

```

If the callback is success and verified, the `MyHandler.handle_success/2`
is called with the `Plug.Conn.t` object and a result map.

