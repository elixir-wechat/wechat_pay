defmodule WechatPay.PaymentMethod.App do
  @moduledoc """
  Module for the
  *[App](https://pay.weixin.qq.com/wiki/doc/api/app/app.php?chapter=8_1)*
  payment method
  """

  @doc """
  Place an order

  [Official document](https://pay.weixin.qq.com/wiki/doc/api/app/app.php?chapter=9_1)
  """
  @callback place_order(
    attrs :: map
  ) :: {:ok, map} | {:error, WechatPay.Error.t | HTTPoison.Error.t}

  @doc """
  Query the order

  [Official document](https://pay.weixin.qq.com/wiki/doc/api/app/app.php?chapter=9_2&index=4)
  """
  @callback query_order(
    attrs :: map
  ) :: {:ok, map} | {:error, WechatPay.Error.t | HTTPoison.Error.t}

  @doc """
  Close the order

  [Official document](https://pay.weixin.qq.com/wiki/doc/api/app/app.php?chapter=9_3&index=5)
  """
  @callback close_order(
    attrs :: map
  ) :: {:ok, map} | {:error, WechatPay.Error.t | HTTPoison.Error.t}

  @doc """
  Request to refund

  [Official document](https://pay.weixin.qq.com/wiki/doc/api/app/app.php?chapter=9_4&index=6)
  """
  @callback refund(
    attrs :: map
  ) :: {:ok, map} | {:error, WechatPay.Error.t | HTTPoison.Error.t}

  @doc """
  Query the refund

  [Official document](https://pay.weixin.qq.com/wiki/doc/api/app/app.php?chapter=9_5&index=7)
  """
  @callback query_refund(
    attrs :: map
  ) :: {:ok, map} | {:error, WechatPay.Error.t | HTTPoison.Error.t}

  @doc """
  Download bill

  [Official document](https://pay.weixin.qq.com/wiki/doc/api/app/app.php?chapter=9_6&index=8)
  """
  @callback download_bill(
    attrs :: map
  ) :: {:ok, String.t} | {:error, HTTPoison.Error.t}

  @doc """
  Report

  [Official document](https://pay.weixin.qq.com/wiki/doc/api/app/app.php?chapter=9_8&index=9)
  """
  @callback report(
    attrs :: map
  ) :: {:ok, map} | {:error, WechatPay.Error.t | HTTPoison.Error.t}

  alias WechatPay.API

  defmacro __using__(opts) do
    quote bind_quoted: [opts: opts] do
      @behaviour WechatPay.PaymentMethod.App

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
    end
  end
end
