# master

⚠️ Breaking changes

* Separate APIs into differnt modules, might be less confusion, one per payment
  method. `WehcatPay.Js`, `WechatPay.Native` and `WechatPay.App` for now.
* `WechatPay.API.get_sandbox_signkey/0` => `WechatPay.Helper.get_sandbox_signkey/0`.
* Extract callback handler as `WechatPay.CallbackHandler`, Which handle the
callback data from Wechat's server.
* Also Rename `WechatPay.Plug.Callback` => `WechatPay.Plug`, now this plug only
takes the responsibility to commutate with Wechat's server, then pass down the
data to the handler.

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
