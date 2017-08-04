defmodule WechatPay.Plug.RefundTest do
  use TestCase, async: false
  use Plug.Test

  alias MyPay.Plug.Refund, as: RefundPlug

  alias WechatPay.PlugTest.Handler

  defmodule Handler do
    use WechatPay.Handler

    @impl WechatPay.Handler
    def handle_data(_conn, data) do
      assert data.out_trade_no == "TODO"
      assert data.refund_status == "SUCCESS"

      :ok

    end

    @impl WechatPay.Handler
    def handle_error(_conn, error, data) do
      assert error == %WechatPay.Error{reason: "Malformed decrypted XML", type: :malformed_decrypted_xml}
      assert data.return_code == "FAIL"
    end
  end

  describe "receive notification from Wechat's Payment Gateway" do
    # TODO: requires a real test sample
    # test "handle success refunding" do
    #   req = ~s"""
    #   <xml>
    #   <return_code>SUCCESS</return_code>
    #     <appid><![CDATA[wx2421b1c4370ec43b]]></appid>
    #     <mch_id><![CDATA[10000100]]></mch_id>
    #     <nonce_str><![CDATA[TeqClE3i0mvn3DrK]]></nonce_str>
    #     <req_info><![CDATA[TODO]]></req_info>
    #   </xml>
    #   """

    #   conn = conn(:post, "/foo", req)

    #   opts = RefundPlug.init([handler: Handler])

    #   RefundPlug.call(conn, opts)
    # end
  end
end
