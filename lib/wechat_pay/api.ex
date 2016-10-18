defmodule WechatPay.API do
  @moduledoc """
  Main module to call Wehcat's API.
  """

  defdelegate place_order(params),
    to: WechatPay.API.PlaceOrder,
    as: :request

  defdelegate query_order(params),
    to: WechatPay.API.QueryOrder,
    as: :request

  defdelegate close_order(params),
    to: WechatPay.API.CloseOrder,
    as: :request

  defdelegate refund(params),
    to: WechatPay.API.Refund,
    as: :request

  defdelegate query_refund(params),
    to: WechatPay.API.QueryRefund,
    as: :request

  defdelegate download_bill(params),
    to: WechatPay.API.DownloadBill,
    as: :request

  defdelegate shorten_url(url),
    to: WechatPay.API.ShortenURL,
    as: :request
end
