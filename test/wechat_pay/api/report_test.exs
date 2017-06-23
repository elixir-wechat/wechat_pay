defmodule WechatPay.API.ReportTest do
  use ExUnit.Case, async: false
  use ExVCR.Mock, adapter: ExVCR.Adapter.Hackney

  alias WechatPay.API

  test "report" do
    use_cassette "report" do
      params = %{
        device_info: "013467007045764",
        interface_url: "https://api.mch.weixin.qq.com/pay/unifiedorder",
        execute_time: 1000,
        return_code: "SUCCESS",
        return_msg: "签名失败",
        result_code: "SUCCESS",
        err_code: "SYSTEMERROR",
        err_code_des: "系统错误",
        out_trade_no: "1217752501201407033233368018",
        user_ip: "8.8.8.8",
        time: "20091227091010"
      }

      {:ok, data} = API.report(params)

      assert data.result_code == "SUCCESS"
    end
  end
end
