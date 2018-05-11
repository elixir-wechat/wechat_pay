defmodule WechatPay.PaymentMethod.Native do
  @moduledoc """
  The **Native** payment method.

  [Official document](https://pay.weixin.qq.com/wiki/doc/api/native.php?chapter=6_1)
  """

  @doc """
  Place an order

  [Official document](https://pay.weixin.qq.com/wiki/doc/api/native.php?chapter=9_1)
  """
  @callback place_order(attrs :: map) ::
              {:ok, map} | {:error, WechatPay.Error.t() | HTTPoison.Error.t()}

  @doc """
  Query the order

  [Official document](https://pay.weixin.qq.com/wiki/doc/api/native.php?chapter=9_2)
  """
  @callback query_order(attrs :: map) ::
              {:ok, map} | {:error, WechatPay.Error.t() | HTTPoison.Error.t()}

  @doc """
  Close the order

  [Official document](https://pay.weixin.qq.com/wiki/doc/api/native.php?chapter=9_3)
  """
  @callback close_order(attrs :: map) ::
              {:ok, map} | {:error, WechatPay.Error.t() | HTTPoison.Error.t()}

  @doc """
  Request to refund

  [Official document](https://pay.weixin.qq.com/wiki/doc/api/native.php?chapter=9_4)
  """
  @callback refund(attrs :: map) ::
              {:ok, map} | {:error, WechatPay.Error.t() | HTTPoison.Error.t()}

  @doc """
  Query the refund

  [Official document](https://pay.weixin.qq.com/wiki/doc/api/native.php?chapter=9_5)
  """
  @callback query_refund(attrs :: map) ::
              {:ok, map} | {:error, WechatPay.Error.t() | HTTPoison.Error.t()}

  @doc """
  Download bill

  [Official document](https://pay.weixin.qq.com/wiki/doc/api/native.php?chapter=9_6)
  """
  @callback download_bill(attrs :: map) :: {:ok, String.t()} | {:error, HTTPoison.Error.t()}

  @doc """
  Report

  [Official document](https://pay.weixin.qq.com/wiki/doc/api/native.php?chapter=9_8)
  """
  @callback report(attrs :: map) ::
              {:ok, map} | {:error, WechatPay.Error.t() | HTTPoison.Error.t()}

  @doc """
  Shorten the URL to reduce the QR image size

  [Official document](https://pay.weixin.qq.com/wiki/doc/api/native.php?chapter=9_9)
  """
  @callback shorten_url(url :: String.t()) ::
              {:ok, String.t()} | {:error, WechatPay.Error.t() | HTTPoison.Error.t()}

  alias WechatPay.API.Client
  alias WechatPay.Config

  import WechatPay.PaymentMethod.Shared

  defmacro __using__(mod) do
    quote do
      @behaviour WechatPay.PaymentMethod.Native

      defdelegate config, to: unquote(mod)

      define_shared_behaviour(WechatPay.PaymentMethod.Native)

      @impl WechatPay.PaymentMethod.Native
      def shorten_url(url), do: WechatPay.PaymentMethod.Native.shorten_url(url, config())
    end
  end

  @doc false
  @spec shorten_url(
          String.t(),
          Config.t()
        ) :: {:ok, String.t()} | {:error, WechatPay.Error.t() | HTTPoison.Error.t()}
  def shorten_url(url, config) do
    Client.post("tools/shorturl", %{long_url: URI.encode(url)}, [], config)
  end
end
