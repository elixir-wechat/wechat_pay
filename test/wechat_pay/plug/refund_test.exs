defmodule WechatPay.Plug.RefundTest do
  use TestCase, async: false
  use Plug.Test

  alias WechatPay.PlugTest.Handler

  defmodule Handler do
    use WechatPay.Plug.Handler

    @impl WechatPay.Plug.Handler
    def handle_data(_conn, data) do
      assert data.out_trade_no == "99999999999999999999999999999999"
      assert data.refund_status == "SUCCESS"

      :ok
    end

    @impl WechatPay.Plug.Handler
    def handle_error(_conn, error, data) do
      assert error == %WechatPay.Error{
               reason: "Malformed decrypted XML",
               type: :malformed_decrypted_xml
             }

      assert data.return_code == "FAIL"
    end
  end

  describe "receive notification from Wechat's Payment Gateway" do
    test "handle success refunding", %{client: client} do
      req = ~s"""
      <xml>
      <return_code>SUCCESS</return_code>
        <app_id><![CDATA[wx2421b1c4370ec43b]]></app_id>
        <mch_id><![CDATA[10000100]]></mch_id>
        <nonce_str><![CDATA[TeqClE3i0mvn3DrK]]></nonce_str>
        <req_info><![CDATA[4gS8kbcHysCW7bHqyEU0M4GTNkgJQP6/zKHbA/E3CvyZ1kyFxob5yLZ/MVNzuc8py3P9bZ/5q+YzfeCs3am4Fo/VN6EyCK9c1oSZIPajwNrIWt36UG9lhdGdYOi14ywDO+I0SWiENSkQgeWL8pB3YX1szHW8UA0nmExbrM7u1coa91uRG/rIpW4D72i3wR5to4kdZtN8E+omK6fkLxN+NkPSS3u2xvdRBans3+SZSRsGo/RlgDPSZRN8Oxyv8YDEQpnX7V42+wB2CTgWf4yAz2Nm6JFS+jUdfLWcHiwFOIAOKEvcACtqxboYmq/H5iiutISroTbDe2FgSOX9aUi8S6XqRsy0GinJWFNSK6KgJz1yFXMpjXLpcvNte2cIbsASEAW19ZEwpaYpiUvoORsbiXWksn0uzlJ0OFHQodqiS9lpoJBvJtrJ4jFajRtg9oiXdr9jpDJcXt2CDNGPgLYiAv55JpoM4nYOFfq5ZPpd+T1nuXNYkq3cldx+aDO8Pq3InAFmOYfMG/tg/CwivVFgPcBJye5c1l1Y41KJa1Wgpp4R6g1BBn1acfteCDdWTfNmkd+JXXXeW/g4CWpy2XpJjN2q5EGN6yPIwbte84KNgbAGoMkjls51B5uKGXtsscr9us7jBkMXlLCQ63swgU1RqVp2t3LTJB5+hbctiaZSYXfGL9XlJcEPqz8s4jTsg6X4Kg7+WNeTEg2BT1tBYOnQkTv1CsQlH1aRLh7eaYFi1isbY0X/BKFvaXglL4gqPf1+mWKfZZjxYFlSfmH+VnCau0s96ey3pTIhzp2YQtUkAm/f5vU3kPgAVi2C7HJ1/s958Iipdzi6ho4MzyZQQNkPlYNbPqmCs2mMCwn+7uNhqD37bWtRGyiQYc6tuPVLmkXfTxulIqCx9G9HdZ0qntkJfcKnZ1EwEQkw2YUu8VPCVCPAxxRqC8TFpqu3gKxheAMSTFVmxmICZXt4Gk746+vMdUrDJlkPnOkhHrRN06wnbiM+foR8ID/ZrIv/PdUCAXXw/B9aB9zNXVv0WZGleNFNA6qONbk/Ne95To6JzOLv2AtnYqMCnSIxGKe/ra5bDIokZSjdwZhoVNVwBb78Z6z3Ag==]]></req_info>
      </xml>
      """

      conn = conn(:post, "/foo", req)

      opts = WechatPay.Plug.Refund.init(handler: Handler, api_key: client.api_key)

      WechatPay.Plug.Refund.call(conn, opts)
    end
  end
end
