defmodule WechatPay.API.Refund do
  @moduledoc """
  Refund API
  """

  alias WechatPay.API.Client

  @api_path "secapi/pay/refund"

  @doc """
  Call the `#{@api_path}` API

  ## Examples

      iex> params = %{
      ...>   device_info: "013467007045764",
      ...>   transaction_id: "1217752501201407033233368018",
      ...>   out_trade_no: "1217752501201407033233368018",
      ...>   out_refund_no: "1217752501201407033233368018",
      ...>   total_fee: 100,
      ...>   refund_fee: 100,
      ...>   refund_fee_type: "CNY",
      ...>   op_user_id: "1900000109",
      ...>   refund_account: "REFUND_SOURCE_RECHARGE_FUNDS"
      ...> }
      iex> WechatPay.API.Refund.request(params)
      {:ok, data}
  """
  def request(params \\ %{}) do
    request_data =
      WechatPay.API.Refund.RequestData
      |> struct(params)

    Client.ssl_post(@api_path, request_data)
  end

  defmodule RequestData do
    @moduledoc false

    defstruct [
      device_info: nil,
      transaction_id: nil,
      out_trade_no: nil,
      out_refund_no: nil,
      total_fee: nil,
      refund_fee: nil,
      refund_fee_type: nil,
      op_user_id: nil,
      refund_account: nil
    ]
  end
end
