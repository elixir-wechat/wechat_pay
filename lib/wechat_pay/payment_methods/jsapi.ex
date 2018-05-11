defmodule WechatPay.PaymentMethod.JSAPI do
  @moduledoc """
  The **JSAPI** payment method.

  [Official document](https://pay.weixin.qq.com/wiki/doc/api/jsapi.php?chapter=7_1)
  """

  @doc """
  Place an order

  [Official document](https://pay.weixin.qq.com/wiki/doc/api/jsapi.php?chapter=9_1)
  """
  @callback place_order(attrs :: map) ::
              {:ok, map} | {:error, WechatPay.Error.t() | HTTPoison.Error.t()}

  @doc """
  Query the order

  [Official document](https://pay.weixin.qq.com/wiki/doc/api/jsapi.php?chapter=9_2)
  """
  @callback query_order(attrs :: map) ::
              {:ok, map} | {:error, WechatPay.Error.t() | HTTPoison.Error.t()}

  @doc """
  Close the order

  [Official document](https://pay.weixin.qq.com/wiki/doc/api/jsapi.php?chapter=9_3)
  """
  @callback close_order(attrs :: map) ::
              {:ok, map} | {:error, WechatPay.Error.t() | HTTPoison.Error.t()}

  @doc """
  Request to refund

  [Official document](https://pay.weixin.qq.com/wiki/doc/api/jsapi.php?chapter=9_4)
  """
  @callback refund(attrs :: map) ::
              {:ok, map} | {:error, WechatPay.Error.t() | HTTPoison.Error.t()}

  @doc """
  Query the refund

  [Official document](https://pay.weixin.qq.com/wiki/doc/api/jsapi.php?chapter=9_5)
  """
  @callback query_refund(attrs :: map) ::
              {:ok, map} | {:error, WechatPay.Error.t() | HTTPoison.Error.t()}

  @doc """
  Download bill

  [Official document](https://pay.weixin.qq.com/wiki/doc/api/jsapi.php?chapter=9_6)
  """
  @callback download_bill(attrs :: map) :: {:ok, String.t()} | {:error, HTTPoison.Error.t()}

  @doc """
  Report

  [Official document](https://pay.weixin.qq.com/wiki/doc/api/jsapi.php?chapter=9_8)
  """
  @callback report(attrs :: map) ::
              {:ok, map} | {:error, WechatPay.Error.t() | HTTPoison.Error.t()}

  @doc """
  Generate pay request info, which is required for the JavaScript API

  [Official document](https://pay.weixin.qq.com/wiki/doc/api/jsapi.php?chapter=7_7&index=6)
  """
  @callback generate_pay_request(prepay_id :: String.t()) :: map

  alias WechatPay.Utils.NonceStr
  alias WechatPay.Utils.Signature
  alias WecahtPay.Config

  import WechatPay.PaymentMethod.Shared

  defmacro __using__(mod) do
    quote do
      @behaviour WechatPay.PaymentMethod.JSAPI

      defdelegate config, to: unquote(mod)

      define_shared_behaviour(WechatPay.PaymentMethod.JSAPI)

      @impl WechatPay.PaymentMethod.JSAPI
      def generate_pay_request(prepay_id),
        do: WechatPay.PaymentMethod.JSAPI.generate_pay_request(prepay_id, config())
    end
  end

  @doc false
  @spec generate_pay_request(String.t(), Config.t()) :: map
  def generate_pay_request(prepay_id, config) do
    %{
      "appId" => config.appid,
      "timeStamp" => Integer.to_string(:os.system_time()),
      "nonceStr" => NonceStr.generate(),
      "package" => "prepay_id=#{prepay_id}",
      "signType" => "MD5"
    }
    |> sign(config.apikey)
  end

  defp sign(data, apikey) do
    data
    |> Map.merge(%{"paySign" => Signature.sign(data, apikey)})
  end
end
