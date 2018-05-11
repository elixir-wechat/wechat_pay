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

  alias WechatPay.API
  alias WechatPay.Utils.NonceStr
  alias WechatPay.Utils.Signature
  alias WechatPay.Config

  defmacro __using__(opts) do
    quote bind_quoted: [opts: opts] do
      @behaviour WechatPay.PaymentMethod.App

      mod = Keyword.fetch!(opts, :mod)

      defdelegate config, to: mod

      @impl WechatPay.PaymentMethod.App
      def place_order(attrs), do: API.place_order(attrs, config())

      @impl WechatPay.PaymentMethod.App
      def query_order(attrs), do: API.query_order(attrs, config())

      @impl WechatPay.PaymentMethod.App
      def close_order(attrs), do: API.close_order(attrs, config())

      @impl WechatPay.PaymentMethod.App
      def refund(attrs), do: API.refund(attrs, config())

      @impl WechatPay.PaymentMethod.App
      def query_refund(attrs), do: API.query_refund(attrs, config())

      @impl WechatPay.PaymentMethod.App
      def download_bill(attrs), do: API.download_bill(attrs, config())

      @impl WechatPay.PaymentMethod.App
      def report(attrs), do: API.report(attrs, config())

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
