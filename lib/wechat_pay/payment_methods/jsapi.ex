defmodule WechatPay.JSAPI do
  @moduledoc """
  The **JSAPI** payment method.

  [Official document](https://pay.weixin.qq.com/wiki/doc/api/jsapi.php?chapter=7_1)
  """

  alias WechatPay.Utils.NonceStr
  alias WechatPay.Utils.Signature
  alias WechatPay.Config
  alias WechatPay.API

  import WechatPay.Shared

  defmacro __using__(mod) do
    quote do
      @behaviour WechatPay.JSAPI.Behaviour

      defdelegate config, to: unquote(mod)

      define_shared_behaviour(WechatPay.JSAPI.Behaviour)

      @impl WechatPay.JSAPI.Behaviour
      def generate_pay_request(prepay_id),
        do: WechatPay.JSAPI.generate_pay_request(prepay_id, config())
    end
  end

  @doc """
  Place an order

  [Official document](https://pay.weixin.qq.com/wiki/doc/api/jsapi.php?chapter=9_1)
  """
  @spec place_order(map, Config.t()) ::
          {:ok, map} | {:error, WechatPay.Error.t() | HTTPoison.Error.t()}
  defdelegate place_order(attrs, config), to: API

  @doc """
  Query the order

  [Official document](https://pay.weixin.qq.com/wiki/doc/api/jsapi.php?chapter=9_2)
  """
  @spec query_order(map, Configt.t()) ::
          {:ok, map} | {:error, WechatPay.Error.t() | HTTPoison.Error.t()}
  defdelegate query_order(attrs, config), to: API

  @doc """
  Close the order

  [Official document](https://pay.weixin.qq.com/wiki/doc/api/jsapi.php?chapter=9_3)
  """
  @spec close_order(map, Config.t()) ::
          {:ok, map} | {:error, WechatPay.Error.t() | HTTPoison.Error.t()}
  defdelegate close_order(attrs, config), to: API

  @doc """
  Request to refund

  [Official document](https://pay.weixin.qq.com/wiki/doc/api/jsapi.php?chapter=9_4)
  """
  @spec refund(map, Config.t()) ::
          {:ok, map} | {:error, WechatPay.Error.t() | HTTPoison.Error.t()}
  defdelegate refund(attrs, config), to: API

  @doc """
  Query the refund

  [Official document](https://pay.weixin.qq.com/wiki/doc/api/jsapi.php?chapter=9_5)
  """
  @spec query_refund(map, Config.t()) ::
          {:ok, map} | {:error, WechatPay.Error.t() | HTTPoison.Error.t()}
  defdelegate query_refund(attrs, config), to: API

  @doc """
  Download bill

  [Official document](https://pay.weixin.qq.com/wiki/doc/api/jsapi.php?chapter=9_6)
  """
  @spec download_bill(map, Config.t()) :: {:ok, String.t()} | {:error, HTTPoison.Error.t()}
  defdelegate download_bill(attrs, config), to: API

  @doc """
  Report

  [Official document](https://pay.weixin.qq.com/wiki/doc/api/jsapi.php?chapter=9_8)
  """
  @spec report(map, Config.t()) ::
          {:ok, map} | {:error, WechatPay.Error.t() | HTTPoison.Error.t()}
  defdelegate report(attrs, config), to: API

  @doc """
  Generate pay request info, which is required for the JavaScript API

  [Official document](https://pay.weixin.qq.com/wiki/doc/api/jsapi.php?chapter=7_7&index=6)
  """
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
