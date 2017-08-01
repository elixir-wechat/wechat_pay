defmodule TestCase do
  defmodule Pay do
    use WechatPay, otp_app: :wechat_pay
  end

  use ExUnit.CaseTemplate

  using do
    quote do
      alias TestCase.Pay

      use ExUnit.Case, async: false
    end
  end

  setup do
    config = [
      env: :sandbox,
      appid: "wx8888888888888888",
      mch_id: "1900000109",
      apikey: "192006250b4c09247ec02edce69f6a2d",
      ssl_cacertfile: "fixture/certs/all.pem",
      ssl_certfile: "fixture/certs/apiclient_cert.pem",
      ssl_keyfile: "fixture/certs/apiclient_key.pem",
      ssl_password: ""
    ]

    [config: config]
  end
end
