# master

* Fixes warnings on Elixir 1.4.
* Added `WechatPay.API.Client.get_sandbox_signkey/0` to get sandbox signkey.
* Rename `WechatPay.Plug.Notify` -> `WechatPay.Plug.Callback`, and rewrite the
  flow. Now it's easier to handle callbacks from Wehcat's Payment Gateway.
* Drop support for loading config from `{:system, ENV}`. It seems not a good
  idea to do this, consider https://github.com/bitwalker/conform.

# v0.1.1

* Fixes hexdocs.pm does not recognize upcase in URL.
* Improve docs.

# v0.1.0

* Initial support Wechat Pay's JSAPI, Native and App.
