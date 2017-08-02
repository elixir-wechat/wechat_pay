defmodule WechatPay.PaymentMethod.Native do
  @moduledoc """
  Module for the
  *[Native](https://pay.weixin.qq.com/wiki/doc/api/native.php?chapter=6_1)*
  payment method
  """

  @doc """
  Place an order

  [Official document](https://pay.weixin.qq.com/wiki/doc/api/native.php?chapter=9_1)
  """
  @callback place_order(
    attrs :: map
  ) :: {:ok, map} | {:error, WechatPay.Error.t | HTTPoison.Error.t}

  @doc """
  Query the order

  [Official document](https://pay.weixin.qq.com/wiki/doc/api/native.php?chapter=9_2)
  """
  @callback query_order(
    attrs :: map
  ) :: {:ok, map} | {:error, WechatPay.Error.t | HTTPoison.Error.t}

  @doc """
  Close the order

  [Official document](https://pay.weixin.qq.com/wiki/doc/api/native.php?chapter=9_3)
  """
  @callback close_order(
    attrs :: map
  ) :: {:ok, map} | {:error, WechatPay.Error.t | HTTPoison.Error.t}

  @doc """
  Request to refund

  [Official document](https://pay.weixin.qq.com/wiki/doc/api/native.php?chapter=9_4)
  """
  @callback refund(
    attrs :: map
  ) :: {:ok, map} | {:error, WechatPay.Error.t | HTTPoison.Error.t}

  @doc """
  Query the refund

  [Official document](https://pay.weixin.qq.com/wiki/doc/api/native.php?chapter=9_5)
  """
  @callback query_refund(
    attrs :: map
  ) :: {:ok, map} | {:error, WechatPay.Error.t | HTTPoison.Error.t}

  @doc """
  Download bill

  [Official document](https://pay.weixin.qq.com/wiki/doc/api/native.php?chapter=9_6)
  """
  @callback download_bill(
    attrs :: map
  ) :: {:ok, String.t} | {:error, HTTPoison.Error.t}

  @doc """
  Report

  [Official document](https://pay.weixin.qq.com/wiki/doc/api/native.php?chapter=9_8)
  """
  @callback report(
    attrs :: map
  ) :: {:ok, map} | {:error, WechatPay.Error.t | HTTPoison.Error.t}

  @doc """
  Shorten the URL to reduce the QR image size

  [Official document](https://pay.weixin.qq.com/wiki/doc/api/native.php?chapter=9_9)
  """
  @callback shorten_url(
    url :: String.t
  ) :: {:ok, String.t} | {:error, WechatPay.Error.t | HTTPoison.Error.t}

  alias WechatPay.API
  alias WechatPay.API.Client

  defmacro __using__(opts) do
    quote bind_quoted: [opts: opts] do
      @behaviour WechatPay.PaymentMethod.Native

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
      def shorten_url(url) do
        Client.post("tools/shorturl", %{long_url: URI.encode(url)}, [], get_config())
      end
    end
  end
end
