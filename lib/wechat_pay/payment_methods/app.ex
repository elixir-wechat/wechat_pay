defmodule WechatPay.App do
  @moduledoc """
  The **App** payment method.

  [Official document](https://pay.weixin.qq.com/wiki/doc/api/app/app.php?chapter=8_1)
  """

  alias WechatPay.Utils.NonceStr
  alias WechatPay.Utils.Signature
  alias WechatPay.Config
  alias WechatPay.API

  import WechatPay.Shared

  defmacro __using__(mod) do
    quote do
      @behaviour WechatPay.App.Behaviour

      defdelegate config, to: unquote(mod)

      define_shared_behaviour(WechatPay.App.Behaviour)

      @impl WechatPay.App.Behaviour
      def generate_pay_request(prepay_id),
        do: WechatPay.App.generate_pay_request(prepay_id, config())
    end
  end

  @doc """
  Place an order

  [Official document](https://pay.weixin.qq.com/wiki/doc/api/app/app.php?chapter=9_1)
  """
  @spec place_order(map, Config.t()) ::
          {:ok, map} | {:error, WechatPay.Error.t() | HTTPoison.Error.t()}
  defdelegate place_order(attrs, config), to: API

  @doc """
  Query the order

  [Official document](https://pay.weixin.qq.com/wiki/doc/api/app/app.php?chapter=9_2&index=4)
  """
  @spec query_order(map, Configt.t()) ::
          {:ok, map} | {:error, WechatPay.Error.t() | HTTPoison.Error.t()}
  defdelegate query_order(attrs, config), to: API

  @doc """
  Close the order

  [Official document](https://pay.weixin.qq.com/wiki/doc/api/app/app.php?chapter=9_3&index=5)
  """
  @spec close_order(map, Config.t()) ::
          {:ok, map} | {:error, WechatPay.Error.t() | HTTPoison.Error.t()}
  defdelegate close_order(attrs, config), to: API

  @doc """
  Request to refund

  [Official document](https://pay.weixin.qq.com/wiki/doc/api/app/app.php?chapter=9_4&index=6)
  """
  @spec refund(map, Config.t()) ::
          {:ok, map} | {:error, WechatPay.Error.t() | HTTPoison.Error.t()}
  defdelegate refund(attrs, config), to: API

  @doc """
  Query the refund

  [Official document](https://pay.weixin.qq.com/wiki/doc/api/app/app.php?chapter=9_5&index=7)
  """
  @spec query_refund(map, Config.t()) ::
          {:ok, map} | {:error, WechatPay.Error.t() | HTTPoison.Error.t()}
  defdelegate query_refund(attrs, config), to: API

  @doc """
  Download bill

  [Official document](https://pay.weixin.qq.com/wiki/doc/api/app/app.php?chapter=9_6&index=8)
  """
  @spec download_bill(map, Config.t()) :: {:ok, String.t()} | {:error, HTTPoison.Error.t()}
  defdelegate download_bill(attrs, config), to: API

  @doc """
  Report

  [Official document](https://pay.weixin.qq.com/wiki/doc/api/app/app.php?chapter=9_8&index=9)
  """
  @spec report(map, Config.t()) ::
          {:ok, map} | {:error, WechatPay.Error.t() | HTTPoison.Error.t()}
  defdelegate report(attrs, config), to: API

  @doc """
  Generate pay request info, which is required for the App SDK

  [Official document](https://pay.weixin.qq.com/wiki/doc/api/app/app.php?chapter=9_12&index=2)
  """
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
