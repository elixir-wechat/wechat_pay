use Mix.Config

config :wechat_pay,
  env: :production,
  appid: {:system, "WECHAT_PAY_APP_ID"},
  mch_id: {:system, "WECHAT_PAY_MCH_ID"},
  apikey: {:system, "WECHAT_API_KEY"}

