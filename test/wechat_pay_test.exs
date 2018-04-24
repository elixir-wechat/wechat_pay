defmodule WechatPayTest do
  use ExUnit.Case
  doctest WechatPay

  test "the truth" do
    assert 1 + 1 == 2
  end

  test "using WechatPay with a custom config function" do
    defmodule MyPayWithConfig do
      use WechatPay

      def config do
        [
          apikey: "foobar"
        ]
      end
    end

    assert MyPayWithConfig.App.generate_pay_request("xxx")
  end
end
