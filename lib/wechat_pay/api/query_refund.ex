defmodule WechatPay.API.QueryRefund do
  @moduledoc """
  Query Refund API
  """

  alias WechatPay.API.Client

  @api_path "pay/refundquery"

  @doc """
  Call the `#{@api_path}` API

  ## Examples

      iex> WechatPay.API.QueryRefund.request(%{device_info: "WEB", out_trade_no: "1415757673"})
      {:ok, data}
  """
  def request(params \\ %{}) do
    request_data =
      WechatPay.API.QueryRefund.RequestData
      |> struct(params)

    Client.post(@api_path, request_data)
  end

  defmodule RequestData do
    @moduledoc false

    defstruct [
      device_info: nil,
      transaction_id: nil,
      out_trade_no: nil,
      out_refund_no: nil,
      refund_id: nil
    ]
  end
end
