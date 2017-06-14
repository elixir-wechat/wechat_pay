defmodule WechatPay.API.CloseOrder do
  @moduledoc """
  Close Order API
  """

  alias WechatPay.API.Client

  @api_path "pay/closeorder"

  @doc """
  Call the `#{@api_path}` API

  ## Examples

      iex> WechatPay.API.CloseOrder.request(%{out_trade_no: "1415757673"})
      {:ok, data}
  """
  @spec request(map) :: {:ok, map} | {:error, WechatPay.Error.t | HTTPoison.Error.t}
  def request(params \\ %{}) do
    order =
      WechatPay.API.CloseOrder.Order
      |> struct(params)

    Client.post(@api_path, order)
  end

  defmodule Order do
    @moduledoc false

    defstruct [
      out_trade_no: nil
    ]
  end
end
