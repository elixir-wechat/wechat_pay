# Configuration

## Standard Application

The most common way is to load configuration from Mix Config:

1. Define the implementation module

```elixir
defmodule MyPay do
  use WechatPay, otp_app: :my_app
end
```

2. Config the app with the Mix Config

```elixir
# config/config.exs
config :my_app, MyPay,
  apikey: "xxxx"
```

3. Call functions on your implementation module 

```elixir
MyPay.App.place_order(%{})
```

## Umbrella Application

If you are building umbrella apps, you can also load mix configuration per app:

Alice App:

```elixir
# Define the implementation module
defmodule AlicePay do
  use WechatPay, otp_app: :alice_app
end

# Config in config/config.exs
config :alice_app, AlicePay,
  apikey: "xxxx"
```

Bob App:

```elixir
# Define the implementation module
defmodule BobPay do
  use WechatPay, otp_app: :bob_app
end

# Config in config/config.exs
config :bob_app, BobPay,
  apikey: "xxxx"
```

## Load config from an external resource

Sometimes you might want to load the config from an ETS table, a file or external API calls.
You can override the `config/0` function and return a `WechatPay.Config` strcut to set the config dynamically.

```elixir
defmodule MyPay do
  use WechatPay

  @impl WechatPay.Config
  def config do
    # returns a %WechatPay.Config{}
  end
end
```

## Per function calls

If you are building a multi-tenancy application, you might want to use a different config for each tenant:

```elixir
alice_config = config_for_tenant(alice_tenant)

WechatPay.App.place_order(%{}, alice_config)

bob_config = config_for_tenant(bob_tenant)

WechatPay.Native.query_order(%{}, bob_config)
```

Check `WechatPay.App`, `WechatPay.JSAPI` and `WechatPay.Native` for a full documentation.
