defmodule WechatPay.Native do
  @moduledoc """
  The **Native** payment method.

  [Official document](https://pay.weixin.qq.com/wiki/doc/api/native.php?chapter=6_1)
  """

  alias WechatPay.API.Client
  alias WechatPay.Config
  alias WechatPay.API

  import WechatPay.Shared

  defmacro __using__(mod) do
    quote do
      @behaviour WechatPay.Native.Behaviour

      defdelegate config, to: unquote(mod)

      define_shared_behaviour(WechatPay.Native.Behaviour)

      @impl WechatPay.Native.Behaviour
      def shorten_url(url), do: WechatPay.Native.shorten_url(url, config())
    end
  end

  @doc """
  Place an order

  [Official document](https://pay.weixin.qq.com/wiki/doc/api/native.php?chapter=9_1)
  """
  @spec place_order(map, Config.t()) ::
          {:ok, map} | {:error, WechatPay.Error.t() | HTTPoison.Error.t()}
  defdelegate place_order(attrs, config), to: API

  @doc """
  Query the order

  [Official document](https://pay.weixin.qq.com/wiki/doc/api/native.php?chapter=9_2)
  """
  @spec query_order(map, Configt.t()) ::
          {:ok, map} | {:error, WechatPay.Error.t() | HTTPoison.Error.t()}
  defdelegate query_order(attrs, config), to: API

  @doc """
  Close the order

  [Official document](https://pay.weixin.qq.com/wiki/doc/api/native.php?chapter=9_3)
  """
  @spec close_order(map, Config.t()) ::
          {:ok, map} | {:error, WechatPay.Error.t() | HTTPoison.Error.t()}
  defdelegate close_order(attrs, config), to: API

  @doc """
  Request to refund

  [Official document](https://pay.weixin.qq.com/wiki/doc/api/native.php?chapter=9_4)
  """
  @spec refund(map, Config.t()) ::
          {:ok, map} | {:error, WechatPay.Error.t() | HTTPoison.Error.t()}
  defdelegate refund(attrs, config), to: API

  @doc """
  Query the refund

  [Official document](https://pay.weixin.qq.com/wiki/doc/api/native.php?chapter=9_5)
  """
  @spec query_refund(map, Config.t()) ::
          {:ok, map} | {:error, WechatPay.Error.t() | HTTPoison.Error.t()}
  defdelegate query_refund(attrs, config), to: API

  @doc """
  Download bill

  [Official document](https://pay.weixin.qq.com/wiki/doc/api/native.php?chapter=9_6)
  """
  @spec download_bill(map, Config.t()) :: {:ok, String.t()} | {:error, HTTPoison.Error.t()}
  defdelegate download_bill(attrs, config), to: API

  @doc """
  Report

  [Official document](https://pay.weixin.qq.com/wiki/doc/api/native.php?chapter=9_8)
  """
  @spec report(map, Config.t()) ::
          {:ok, map} | {:error, WechatPay.Error.t() | HTTPoison.Error.t()}
  defdelegate report(attrs, config), to: API

  @doc """
  Shorten the URL to reduce the QR image size

  [Official document](https://pay.weixin.qq.com/wiki/doc/api/native.php?chapter=9_9)
  """
  @spec shorten_url(
          String.t(),
          Config.t()
        ) :: {:ok, String.t()} | {:error, WechatPay.Error.t() | HTTPoison.Error.t()}
  def shorten_url(url, config) do
    Client.post("tools/shorturl", %{long_url: URI.encode(url)}, [], config)
  end
end
