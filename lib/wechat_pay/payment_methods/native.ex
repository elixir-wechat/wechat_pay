defmodule WechatPay.Native do
  @moduledoc """
  The **Native** payment method.

  [Official document](https://pay.weixin.qq.com/wiki/doc/api/native.php?chapter=6_1)

  ## Example

  Set up a client:

  ```elixir
  client = WechatPay.Client.new(
    app_id: "the-app_id",
    mch_id: "the-mch-id",
    api_key: "the-api_key",
    ssl: [
        ca_cert: File.read!("fixture/certs/rootca.pem"),
        cert: File.read!("fixture/certs/apiclient_cert.pem"),
        key: File.read!("fixture/certs/apiclient_key.pem")
    ]
  )
  ```

  Place an order:

  ```elixir
  WechatPay.Native.place_order(client, %{
    body: "Plan 1",
    out_trade_no: "12345",
    fee_type: "CNY",
    total_fee: "600",
    spbill_create_ip: Void.Utils.get_system_ip(),
    notify_url: "http://example.com/",
    trade_type: "Native",
    product_id: "12345"
  })
  ```
  """

  alias WechatPay.Client
  alias WechatPay.API
  alias WechatPay.API.HTTPClient
  alias WechatPay.Utils.Signature

  @doc """
  Place an order

  [Official document](https://pay.weixin.qq.com/wiki/doc/api/native.php?chapter=9_1)
  """
  @spec place_order(Client.t(), map, keyword) ::
          {:ok, map} | {:error, WechatPay.Error.t() | HTTPoison.Error.t()}
  defdelegate place_order(client, attrs, options \\ []), to: API

  @doc """
  Query the order

  [Official document](https://pay.weixin.qq.com/wiki/doc/api/native.php?chapter=9_2)
  """
  @spec query_order(Client.t(), map, keyword) ::
          {:ok, map} | {:error, WechatPay.Error.t() | HTTPoison.Error.t()}
  defdelegate query_order(client, attrs, options \\ []), to: API

  @doc """
  Close the order

  [Official document](https://pay.weixin.qq.com/wiki/doc/api/native.php?chapter=9_3)
  """
  @spec close_order(Client.t(), map, keyword) ::
          {:ok, map} | {:error, WechatPay.Error.t() | HTTPoison.Error.t()}
  defdelegate close_order(client, attrs, options \\ []), to: API

  @doc """
  Request to refund

  [Official document](https://pay.weixin.qq.com/wiki/doc/api/native.php?chapter=9_4)
  """
  @spec refund(Client.t(), map, keyword) ::
          {:ok, map} | {:error, WechatPay.Error.t() | HTTPoison.Error.t()}
  defdelegate refund(client, attrs, options \\ []), to: API

  @doc """
  Query the refund

  [Official document](https://pay.weixin.qq.com/wiki/doc/api/native.php?chapter=9_5)
  """
  @spec query_refund(Client.t(), map, keyword) ::
          {:ok, map} | {:error, WechatPay.Error.t() | HTTPoison.Error.t()}
  defdelegate query_refund(client, attrs, options \\ []), to: API

  @doc """
  Download bill

  [Official document](https://pay.weixin.qq.com/wiki/doc/api/native.php?chapter=9_6)
  """
  @spec download_bill(Client.t(), map, keyword) ::
          {:ok, String.t()} | {:error, HTTPoison.Error.t()}
  defdelegate download_bill(client, attrs, options \\ []), to: API

  @doc """
  Report

  [Official document](https://pay.weixin.qq.com/wiki/doc/api/native.php?chapter=9_8)
  """
  @spec report(Client.t(), map, keyword) ::
          {:ok, map} | {:error, WechatPay.Error.t() | HTTPoison.Error.t()}
  defdelegate report(client, attrs, options \\ []), to: API

  @doc """
  Shorten the URL to reduce the QR image size

  [Official document](https://pay.weixin.qq.com/wiki/doc/api/native.php?chapter=9_9)
  """
  @spec shorten_url(Client.t(), String.t(), keyword) ::
          {:ok, String.t()} | {:error, WechatPay.Error.t() | HTTPoison.Error.t()}
  def shorten_url(client, url, options \\ []) do
    with {:ok, data} <-
           HTTPClient.post(client, "tools/shorturl", %{long_url: URI.encode(url)}, options),
         :ok <- Signature.verify(data, client.api_key) do
      {:ok, data}
    end
  end
end
