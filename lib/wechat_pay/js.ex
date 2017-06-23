defmodule WechatPay.Js do
  @moduledoc """
  Module for the *JSAPI* payment method

  [API document](https://pay.weixin.qq.com/wiki/doc/api/jsapi.php?chapter=9_1)
  """

  alias WechatPay.API
  alias WechatPay.Config
  alias WechatPay.Utils.NonceStr
  alias WechatPay.Utils.Signature

  defdelegate place_order(attrs, opts \\ []), to: API

  defdelegate query_order(attrs, opts \\ []), to: API

  defdelegate close_order(attrs, opts \\ []), to: API

  defdelegate refund(attrs, opts \\ []), to: API

  defdelegate query_refund(attrs, opts \\ []), to: API

  defdelegate download_bill(attrs, opts \\ []), to: API

  defdelegate report(attrs, opts \\ []), to: API

  @doc """
  Generate pay request used inside Wehcat's Browser

  ## Example

      iex> WechatPay.Js.generate_pay_request
      %{
        "appId" => "wx2421b1c4370ec43b",
        "timeStamp" => "1395712654",
        "nonceStr" => "e61463f8efa94090b1f366cccfbbb444",
        "package" => "prepay_id=u802345jgfjsdfgsdg888",
        "signType" => "MD5",
        "paySign" => "70EA570631E4BB79628FBCA90534C63FF7FADD89"
       }
  """
  @spec generate_pay_request(String.t) :: map
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
