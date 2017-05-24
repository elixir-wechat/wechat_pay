defmodule WechatPay.Plug.CallbackTest do
  use ExUnit.Case, async: false
  use Plug.Test

  alias WechatPay.Plug.Callback

  @behaviour WechatPay.Plug.Callback.Handler

  def handle_success(_conn, data) do
    assert data.appid == "wx2421b1c4370ec43b"
    assert data.result_code == "SUCCESS"
  end

  def handle_error(_conn, reason, data) do
    assert reason == "签名失败"
    assert data.return_code == "FAIL"
  end

  describe "receive notification from Wechat's payment gateway" do
    test "handle success" do
      req = ~s"""
      <xml>
        <appid><![CDATA[wx2421b1c4370ec43b]]></appid>
        <attach><![CDATA[支付测试]]></attach>
        <bank_type><![CDATA[CFT]]></bank_type>
        <fee_type><![CDATA[CNY]]></fee_type>
        <is_subscribe><![CDATA[Y]]></is_subscribe>
        <mch_id><![CDATA[10000100]]></mch_id>
        <nonce_str><![CDATA[5d2b6c2a8db53831f7eda20af46e531c]]></nonce_str>
        <openid><![CDATA[oUpF8uMEb4qRXf22hE3X68TekukE]]></openid>
        <out_trade_no><![CDATA[1409811653]]></out_trade_no>
        <result_code><![CDATA[SUCCESS]]></result_code>
        <return_code><![CDATA[SUCCESS]]></return_code>
        <sign><![CDATA[594B6D97F089D24B55156CE09A5FF412]]></sign>
        <sub_mch_id><![CDATA[10000100]]></sub_mch_id>
        <time_end><![CDATA[20140903131540]]></time_end>
        <total_fee>1</total_fee>
        <trade_type><![CDATA[JSAPI]]></trade_type>
        <transaction_id><![CDATA[1004400740201409030005092168]]></transaction_id>
      </xml>
      """

      conn = conn(:post, "/foo", req)

      opts = Callback.init([handler: WechatPay.Plug.CallbackTest])

      Callback.call(conn, opts)
    end

    test "handle error" do
      req = ~s"""
      <xml>
        <return_code><![CDATA[FAIL]]></return_code>
        <return_msg><![CDATA[签名失败]]></return_msg>
      </xml>
      """

      conn = conn(:post, "/foo", req)

      opts = Callback.init([handler: WechatPay.Plug.CallbackTest])
      Callback.call(conn, opts)
    end
  end
end
