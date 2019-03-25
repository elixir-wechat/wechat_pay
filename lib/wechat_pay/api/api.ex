defmodule WechatPay.API do
  @moduledoc """
  The Core API module
  """

  alias WechatPay.API.HTTPClient
  alias WechatPay.Client
  alias WechatPay.Utils.Signature
  alias WechatPay.Error

  @doc """
  Request to close the order

  ## Examples

      iex> WechatPay.API.close_order(%{out_trade_no: "1415757673"})
      ...> {:ok, data}
  """
  @spec close_order(Client.t(), map, keyword) ::
          {:ok, map} | {:error, Error.t() | HTTPoison.Error.t()}
  def close_order(client, attrs, options \\ []) do
    with {:ok, data} <- HTTPClient.post(client, "pay/closeorder", attrs, options),
         :ok <- Signature.verify(data, client.api_key, client.sign_type) do
      {:ok, data}
    end
  end

  @doc """
  Place an unified order

  ## Examples

      iex> WechatPay.API.place_order(%{
        device_info: "WEB",
        body: "Wechat-666",
        attach: nil,
        out_trade_no: "1415757673",
        fee_type: "CNY",
        total_fee: 709,
        spbill_create_ip: "127.0.0.1",
        notify_url: "http://example.com/wechat-pay-callback",
        time_start: 20091225091010,
        time_expire: 20091227091010,
        trade_type: "JSAPI",
        openid: "oUpF8uMuAJO_M2pxb1Q9zNjWeS6o",
      })
      ...> {:ok, data}
  """
  @spec place_order(Client.t(), map, keyword) ::
          {:ok, map} | {:error, WechatPay.Error.t() | HTTPoison.Error.t()}
  def place_order(client, attrs, options \\ []) do
    with {:ok, data} <- HTTPClient.post(client, "pay/unifiedorder", attrs, options),
         :ok <- Signature.verify(data, client.api_key, client.sign_type) do
      {:ok, data}
    end
  end

  @doc """
  Query an order

  ## Examples

      iex> WechatPay.API.query_order(%{out_trade_no: "1415757673"})
      ...> {:ok, data}
  """
  @spec query_order(Client.t(), map, keyword) ::
          {:ok, map} | {:error, WechatPay.Error.t() | HTTPoison.Error.t()}
  def query_order(client, attrs, options \\ []) do
    with {:ok, data} <- HTTPClient.post(client, "pay/orderquery", attrs, options),
         :ok <- Signature.verify(data, client.api_key, client.sign_type) do
      {:ok, data}
    end
  end

  @doc """
  Download the bill

  ## Examples

      iex> WechatPay.API.download_bill(%{
        device_info: "013467007045764",
        bill_date: "20140603",
        bill_type: "ALL"
      })
      ...> {:ok, data}
  """
  @spec download_bill(Client.t(), map, keyword) ::
          {:ok, String.t()} | {:error, HTTPoison.Error.t()}
  def download_bill(client, attrs, options \\ []) do
    HTTPClient.download_text(client, "pay/downloadbill", attrs, options)
  end

  @doc """
  Download the fund flow

  ⚠️ This requires the ssl config is set

  ## Examples

      iex> WechatPay.API.download_fund_flow(%{
        account_type: "Basic",
        bill_date: "20140603"
      })
      ...> {:ok, data}
  """
  @spec download_fund_flow(Client.t(), map, keyword) ::
          {:ok, String.t()} | {:error, HTTPoison.Error.t()}
  def download_fund_flow(client, attrs, options \\ []) do
    ssl = client |> load_ssl()

    HTTPClient.download_text(
      client,
      "pay/downloadfundflow",
      attrs,
      Keyword.merge([ssl: ssl], options)
    )
  end

  @doc """
  Query the refund status

  ## Examples

      iex> WechatPay.API.query_refund(%{
        device_info: "WEB",
        out_trade_no: "1415757673"
      })
      ...> {:ok, data}
  """
  @spec query_refund(Client.t(), map, keyword) ::
          {:ok, map} | {:error, WechatPay.Error.t() | HTTPoison.Error.t()}
  def query_refund(client, attrs, options \\ []) do
    with {:ok, data} <- HTTPClient.post(client, "pay/refundquery", attrs, options),
         :ok <- Signature.verify(data, client.api_key, client.sign_type) do
      {:ok, data}
    end
  end

  @doc """
  Request to Refund an order

  ⚠️ This requires the ssl config is set

  ## Examples

      iex> attrs = %{
        device_info: "013467007045764",
        transaction_id: "1217752501201407033233368018",
        out_trade_no: "1217752501201407033233368018",
        out_refund_no: "1217752501201407033233368018",
        total_fee: 100,
        refund_fee: 100,
        refund_fee_type: "CNY",
        op_user_id: "1900000109",
        refund_account: "REFUND_SOURCE_RECHARGE_FUNDS"
      }
      ...> WechatPay.API.refund(attrs, opts)
      ...> {:ok, data}
  """
  @spec refund(Client.t(), map(), keyword()) ::
          {:ok, map} | {:error, WechatPay.Error.t() | HTTPoison.Error.t()}
  def refund(client, attrs, options \\ []) do
    ssl = client |> load_ssl()

    with {:ok, data} <-
           HTTPClient.post(
             client,
             "secapi/pay/refund",
             attrs,
             Keyword.merge([ssl: ssl], options)
           ),
         :ok <- Signature.verify(data, client.api_key, client.sign_type) do
      {:ok, data}
    end
  end

  @doc """
  Call the payitil/report API

  ## Examples

      iex> params = %{
        device_info: "013467007045764",
        interface_url: "https://api.mch.weixin.qq.com/pay/unifiedorder",
        execute_time_: 1000,
        return_code: "SUCCESS",
        return_msg: "签名失败",
        result_code: "SUCCESS",
        err_code: "SYSTEMERROR",
        err_code_des: "系统错误",
        out_trade_no: "1217752501201407033233368018",
        user_ip: "8.8.8.8",
        time: "20091227091010"
      }
      ...> WechatPay.API.report(params)
      ...> {:ok, data}
  """
  @spec report(Client.t(), map, keyword) ::
          {:ok, map} | {:error, WechatPay.Error.t() | HTTPoison.Error.t()}
  def report(client, attrs, options \\ []) do
    HTTPClient.post(client, "payitil/report", attrs, options)
  end

  defp decode_public(nil), do: nil

  defp decode_public(pem) do
    [{:Certificate, der_bin, :not_encrypted}] = :public_key.pem_decode(pem)
    der_bin
  end

  defp decode_private(pem) do
    [{type, der_bin, :not_encrypted}] = :public_key.pem_decode(pem)
    {type, der_bin}
  end

  defp load_ssl(%Client{ssl: nil}) do
    []
  end

  defp load_ssl(%Client{ssl: ssl}) do
    ssl = Enum.into(ssl, %{})

    [
      cacerts: ssl.ca_cert |> decode_public() |> List.wrap(),
      cert: ssl.cert |> decode_public(),
      key: ssl.key |> decode_private()
    ]
    |> Enum.reject(fn {_k, v} -> v == nil end)
  end
end
