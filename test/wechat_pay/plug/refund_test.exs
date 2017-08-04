defmodule WechatPay.Plug.RefundTest do
  use TestCase, async: false
  use Plug.Test

  alias MyPay.Plug.Refund, as: RefundPlug

  alias WechatPay.PlugTest.Handler

  defmodule Handler do
    use WechatPay.Handler

    @impl WechatPay.Handler
    def handle_data(_conn, data) do
      assert data.appid == "wx2421b1c4370ec43b"
      assert data.result_code == "SUCCESS"

      :ok
    end

    @impl WechatPay.Handler
    def handle_error(_conn, error, data) do
      assert error == %WechatPay.Error{reason: "签名失败", type: :failed_return}
      assert data.return_code == "FAIL"
    end
  end

  describe "receive notification from Wechat's Payment Gateway" do
    test "handle data" do
      req = ~s"""
      <xml>
      <return_code>SUCCESS</return_code>
        <appid><![CDATA[wx2421b1c4370ec43b]]></appid>
        <mch_id><![CDATA[10000100]]></mch_id>
        <nonce_str><![CDATA[TeqClE3i0mvn3DrK]]></nonce_str>
        <req_info><![CDATA[T87GAHG17TGAHG1TGHAHAHA1Y1CIOA9UGJH1GAHV871HAGAGQYQQPOOJMXNBCXBVNMNMAJAA]]></req_info>
      </xml>
      """

      conn = conn(:post, "/foo", req)

      opts = RefundPlug.init([handler: Handler])

      RefundPlug.call(conn, opts)
    end
  end
end
