defmodule WechatPay.API.DownloadBill do
  @moduledoc """
  Download bill API
  """

  alias WechatPay.API.Client

  @api_path "pay/downloadbill"

  @doc """
  Call the `#{@api_path}` API

  ## Examples

      iex> WechatPay.API.DownloadBill.request(device_info: "013467007045764", bill_date: "20140603", bill_type: "ALL")
      {:ok, data}
  """
  def request(params \\ %{}) do
    request_data =
      WechatPay.API.DownloadBill.RequestData
      |> struct(params)

    Client.download_text(@api_path, request_data)
  end

  defmodule RequestData do
    @moduledoc false

    defstruct [
      device_info: nil,
      bill_date: nil,
      bill_type: nil
    ]
  end
end
