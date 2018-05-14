defmodule WechatPayTest do
  use ExUnit.Case
  doctest WechatPay

  test "using WechatPay with a custom config function" do
    defmodule MyPayWithConfig do
      use WechatPay

      def config do
        %WechatPay.Config{
          appid: "wx8888888888888888",
          mch_id: "1900000109",
          apikey: "192006250b4c09247ec02edce69f6a2d",
          ssl_cacert: File.read!("fixture/certs/rootca.pem"),
          ssl_cert: File.read!("fixture/certs/apiclient_cert.pem"),
          ssl_key: File.read!("fixture/certs/apiclient_key.pem")
        }
      end
    end

    assert MyPayWithConfig.App.generate_pay_request("xxx")
  end
end
