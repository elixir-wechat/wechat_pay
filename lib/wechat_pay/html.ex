defmodule WechatPay.HTML do
  alias WechatPay.Config
  alias WechatPay.Utils.NonceStr
  alias WechatPay.Utils.Signature

  def generate_pay_request(prepay_id) when is_binary(prepay_id) do
    %{
      "appId" => Config.appid,
      "timeStamp" => Integer.to_string(:os.system_time),
      "nonceStr" => NonceStr.generate,
      "package" => "prepay_id=#{prepay_id}",
      "signType" => "MD5"
    } |> sign
  end

  defp sign(data) do
    data
    |> Map.merge(%{"paySign" => Signature.sign(data)})
  end
end
