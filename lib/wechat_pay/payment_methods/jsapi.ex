defmodule WechatPay.PaymentMethod.JSAPI do
  @moduledoc """
  The **JSAPI** payment method.

  [Official document](https://pay.weixin.qq.com/wiki/doc/api/jsapi.php?chapter=7_1)
  """

  @doc """
  Place an order

  [Official document](https://pay.weixin.qq.com/wiki/doc/api/jsapi.php?chapter=9_1)
  """
  @callback place_order(
    attrs :: map
  ) :: {:ok, map} | {:error, WechatPay.Error.t | HTTPoison.Error.t}

  @doc """
  Query the order

  [Official document](https://pay.weixin.qq.com/wiki/doc/api/jsapi.php?chapter=9_2)
  """
  @callback query_order(
    attrs :: map
  ) :: {:ok, map} | {:error, WechatPay.Error.t | HTTPoison.Error.t}

  @doc """
  Close the order

  [Official document](https://pay.weixin.qq.com/wiki/doc/api/jsapi.php?chapter=9_3)
  """
  @callback close_order(
    attrs :: map
  ) :: {:ok, map} | {:error, WechatPay.Error.t | HTTPoison.Error.t}

  @doc """
  Request to refund

  [Official document](https://pay.weixin.qq.com/wiki/doc/api/jsapi.php?chapter=9_4)
  """
  @callback refund(
    attrs :: map
  ) :: {:ok, map} | {:error, WechatPay.Error.t | HTTPoison.Error.t}

  @doc """
  Query the refund

  [Official document](https://pay.weixin.qq.com/wiki/doc/api/jsapi.php?chapter=9_5)
  """
  @callback query_refund(
    attrs :: map
  ) :: {:ok, map} | {:error, WechatPay.Error.t | HTTPoison.Error.t}

  @doc """
  Download bill

  [Official document](https://pay.weixin.qq.com/wiki/doc/api/jsapi.php?chapter=9_6)
  """
  @callback download_bill(
    attrs :: map
  ) :: {:ok, String.t} | {:error, HTTPoison.Error.t}

  @doc """
  Report

  [Official document](https://pay.weixin.qq.com/wiki/doc/api/jsapi.php?chapter=9_8)
  """
  @callback report(
    attrs :: map
  ) :: {:ok, map} | {:error, WechatPay.Error.t | HTTPoison.Error.t}

  @doc """
  Generate pay request info, which is required for calling the JavaScript API

  [Official document](https://pay.weixin.qq.com/wiki/doc/api/jsapi.php?chapter=7_7&index=6)
  """
  @callback generate_pay_request(
    prepay_id :: String.t
  ) :: map

  alias WechatPay.API
  alias WechatPay.Utils.NonceStr
  alias WechatPay.Utils.Signature

  defmacro __using__(opts) do
    quote bind_quoted: [opts: opts] do
      @behaviour WechatPay.PaymentMethod.JSAPI

      mod = Keyword.fetch!(opts, :mod)

      defdelegate get_config, to: mod

      @impl true
      def place_order(attrs),
        do: API.place_order(attrs, get_config())

      @impl true
      def query_order(attrs),
        do: API.query_order(attrs, get_config())

      @impl true
      def close_order(attrs),
        do: API.close_order(attrs, get_config())

      @impl true
      def refund(attrs),
        do: API.refund(attrs, get_config())

      @impl true
      def query_refund(attrs),
        do: API.query_refund(attrs, get_config())

      @impl true
      def download_bill(attrs),
        do: API.download_bill(attrs, get_config())

      @impl true
      def report(attrs),
        do: API.report(attrs, get_config())

      @impl true
      def generate_pay_request(prepay_id) do
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
