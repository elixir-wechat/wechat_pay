defmodule WechatPay.HTML do
  @moduledoc """
  HTML
  """

  alias WechatPay.Config
  alias WechatPay.Utils.NonceStr
  alias WechatPay.Utils.Signature

  @doc """
  Generate pay request used inside Wehcat's Browser

  ## Example

      iex> WechatPay.HTML.generate_pay_request
      %{
        "appId" => "wx2421b1c4370ec43b",
        "timeStamp" => "1395712654",
        "nonceStr" => "e61463f8efa94090b1f366cccfbbb444",
        "package" => "prepay_id=u802345jgfjsdfgsdg888",
        "signType" => "MD5",
        "paySign" => "70EA570631E4BB79628FBCA90534C63FF7FADD89"
       }
  """
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
