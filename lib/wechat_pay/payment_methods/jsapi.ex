defmodule WechatPay.PaymentMethod.JSAPI do
  @moduledoc """
  Module for the *JSAPI* payment method

  [API document](https://pay.weixin.qq.com/wiki/doc/api/jsapi.php?chapter=9_1)
  """

  alias WechatPay.API
  alias WechatPay.Utils.NonceStr
  alias WechatPay.Utils.Signature

  defmacro __using__(opts) do
    quote bind_quoted: [opts: opts] do
      mod = Keyword.fetch!(opts, :mod)

      defdelegate get_config, to: mod

      def place_order(attrs),
        do: API.place_order(attrs, get_config())

      def query_order(attrs),
        do: API.query_order(attrs, get_config())

      def close_order(attrs),
        do: API.close_order(attrs, get_config())

      def refund(attrs),
        do: API.refund(attrs, get_config())

      def query_refund(attrs),
        do: API.query_refund(attrs, get_config())

      def download_bill(attrs),
        do: API.download_bill(attrs, get_config())

      def report(attrs),
        do: API.report(attrs, get_config())

      @spec generate_pay_request(String.t) :: map
      def generate_pay_request(prepay_id) when is_binary(prepay_id) do
        %{
          "appId" => Keyword.get(get_config(), :appid),
          "timeStamp" => Integer.to_string(:os.system_time),
          "nonceStr" => NonceStr.generate,
          "package" => "prepay_id=#{prepay_id}",
          "signType" => "MD5"
        } |> sign
      end

      defp sign(data) do
        apikey = Keyword.get(get_config(), :apikey)

        data
        |> Map.merge(%{"paySign" => Signature.sign(data, apikey)})
      end
    end
  end
end
