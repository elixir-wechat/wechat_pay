defmodule WechatPay.API.QueryOrder do
  @moduledoc """
  Query Order API
  """

  alias WechatPay.API.Client

  @api_path "pay/orderquery"

  @doc """
  Call the `#{@api_path}` API

  ## Examples

      iex> WechatPay.API.QueryOrder.request(%{out_trade_no: "1415757673"})
      {:ok, data}
  """
  @spec request(map) :: {:ok, map} | {:error, WechatPay.Error.t | HTTPoison.Error.t}
  def request(params \\ %{}) do
    order =
      WechatPay.API.QueryOrder.Order
      |> struct(params)

    Client.post(@api_path, order)
  end

  defmodule Order do
    @moduledoc false

    defstruct [
      transaction_id: nil,
      out_trade_no: nil
    ]
  end
end
