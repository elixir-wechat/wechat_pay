defmodule WechatPay.PaymentMethod.App do
  @moduledoc """
  The **App** payment method.

  [Official document](https://pay.weixin.qq.com/wiki/doc/api/app/app.php?chapter=8_1)
  """

  @doc """
  Place an order

  [Official document](https://pay.weixin.qq.com/wiki/doc/api/app/app.php?chapter=9_1)
  """
  @callback place_order(attrs :: map) ::
              {:ok, map} | {:error, WechatPay.Error.t() | HTTPoison.Error.t()}

  @doc """
  Query the order

  [Official document](https://pay.weixin.qq.com/wiki/doc/api/app/app.php?chapter=9_2&index=4)
  """
  @callback query_order(attrs :: map) ::
              {:ok, map} | {:error, WechatPay.Error.t() | HTTPoison.Error.t()}

  @doc """
  Close the order

  [Official document](https://pay.weixin.qq.com/wiki/doc/api/app/app.php?chapter=9_3&index=5)
  """
  @callback close_order(attrs :: map) ::
              {:ok, map} | {:error, WechatPay.Error.t() | HTTPoison.Error.t()}

  @doc """
  Request to refund

  [Official document](https://pay.weixin.qq.com/wiki/doc/api/app/app.php?chapter=9_4&index=6)
  """
  @callback refund(attrs :: map) ::
              {:ok, map} | {:error, WechatPay.Error.t() | HTTPoison.Error.t()}

  @doc """
  Query the refund

  [Official document](https://pay.weixin.qq.com/wiki/doc/api/app/app.php?chapter=9_5&index=7)
  """
  @callback query_refund(attrs :: map) ::
              {:ok, map} | {:error, WechatPay.Error.t() | HTTPoison.Error.t()}

  @doc """
  Download bill

  [Official document](https://pay.weixin.qq.com/wiki/doc/api/app/app.php?chapter=9_6&index=8)
  """
  @callback download_bill(attrs :: map) :: {:ok, String.t()} | {:error, HTTPoison.Error.t()}

  @doc """
  Report

  [Official document](https://pay.weixin.qq.com/wiki/doc/api/app/app.php?chapter=9_8&index=9)
  """
  @callback report(attrs :: map) ::
              {:ok, map} | {:error, WechatPay.Error.t() | HTTPoison.Error.t()}

  @doc """
  Generate pay request info, which is required for the App SDK

  [Official document](https://pay.weixin.qq.com/wiki/doc/api/app/app.php?chapter=9_12&index=2)
  """
  @callback generate_pay_request(prepay_id :: String.t()) :: map

  alias WechatPay.Utils.NonceStr
  alias WechatPay.Utils.Signature
  alias WechatPay.Config

  import WechatPay.PaymentMethod.Shared

  defmacro __using__(mod) do
    quote do
      @behaviour WechatPay.PaymentMethod.App

      defdelegate config, to: unquote(mod)

      define_shared_behaviour(WechatPay.PaymentMethod.App)

      @impl WechatPay.PaymentMethod.App
      def generate_pay_request(prepay_id),
        do: WechatPay.PaymentMethod.App.generate_pay_request(prepay_id, config())
    end
  end

  @doc false
  @spec generate_pay_request(String.t(), Config.t()) :: map
  def generate_pay_request(prepay_id, config) do
    %{
      "appid" => config.appid,
      "partnerid" => config.mch_id,
      "prepayid" => prepay_id,
      "package" => "Sign=WXPay",
      "noncestr" => NonceStr.generate(),
      "timestamp" => Integer.to_string(:os.system_time())
    }
    |> sign(config.apikey)
  end

  defp sign(data, apikey) do
    data
    |> Map.merge(%{"sign" => Signature.sign(data, apikey)})
  end
end
