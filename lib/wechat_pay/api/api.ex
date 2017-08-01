defmodule WechatPay.API do
  @moduledoc """
  Main module to call Wehcat's API.
  """

  alias WechatPay.API.Client

  @doc """
  Request to close the order

  ## Examples

      iex> WechatPay.API.close_order(%{out_trade_no: "1415757673"})
      ...> {:ok, data}
  """
  @spec close_order(map, WechatPay.config) :: {:ok, map} | {:error, WechatPay.Error.t | HTTPoison.Error.t}
  def close_order(attrs, config) do
    Client.post("pay/closeorder", attrs, [], config)
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
  @spec place_order(map, WechatPay.config) :: {:ok, map} | {:error, WechatPay.Error.t | HTTPoison.Error.t}
  def place_order(attrs, config) do
    Client.post("pay/unifiedorder", attrs, [], config)
  end

  @doc """
  Query an order

  ## Examples

      iex> WechatPay.API.query_order(%{out_trade_no: "1415757673"})
      ...> {:ok, data}
  """
  @spec query_order(map, WechatPay.config) :: {:ok, map} | {:error, WechatPay.Error.t | HTTPoison.Error.t}
  def query_order(attrs, config) do
    Client.post("pay/orderquery", attrs, [], config)
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
  @spec download_bill(map, WechatPay.config) :: {:ok, String.t} | {:error, HTTPoison.Error.t}
  def download_bill(attrs, config) do
    Client.download_text("pay/downloadbill", attrs, [], config)
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
  @spec query_refund(map, WechatPay.config) :: {:ok, map} | {:error, WechatPay.Error.t | HTTPoison.Error.t}
  def query_refund(attrs, config) do
    Client.post("pay/refundquery", attrs, [], config)
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
  @spec refund(map, WechatPay.config) :: {:ok, map} | {:error, WechatPay.Error.t | HTTPoison.Error.t}
  def refund(attrs, config) do
    opts = [
      hackney: [ # :hackney options
        ssl_options: [ # :ssl options
          cacertfile: Keyword.get(config, :ssl_cacertfile),
          certfile: Keyword.get(config, :ssl_certfile),
          keyfile: Keyword.get(config, :ssl_keyfile),
          password: Keyword.get(config, :ssl_password) |> String.to_charlist()
        ]
      ]
    ]

    Client.post("secapi/pay/refund", attrs, opts, config)
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
  @spec report(map, WechatPay.config) :: {:ok, map} | {:error, WechatPay.Error.t | HTTPoison.Error.t}
  def report(attrs, config) do
    config =
      config
      |> Keyword.merge([verify_sign: false])

    Client.post("payitil/report", attrs, [], config)
  end
end
