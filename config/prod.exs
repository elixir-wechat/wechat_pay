use Mix.Config

config :wechat_pay,
  env: :production,
  appid: {:system, "WECHAT_PAY_APP_ID"},
  mch_id: {:system, "WECHAT_PAY_MCH_ID"},
  apikey: {:system, "WECHAT_PAY_API_KEY"},
  ssl_cacertfile: {:system, "WECHAT_PAY_SSL_CA_CERTFILE"},
  ssl_certfile: {:system, "WECHAT_PAY_SSL_CERTFILE"},
  ssl_keyfile: {:system, "WECHAT_PAY_SSL_KEYFILE"},
  ssl_password: {:system, "WECHAT_PAY_SSL_PASSWORD"},

