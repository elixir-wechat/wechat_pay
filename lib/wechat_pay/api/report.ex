defmodule WechatPay.API.Report do
  @moduledoc """
  Report API
  """

  alias WechatPay.API.Client

  @api_path "payitil/report"

  @doc """
  Call the `#{@api_path}` API

  ## Examples

      iex> params = %{
      ...>   device_info: "013467007045764",
      ...>   interface_url: "https://api.mch.weixin.qq.com/pay/unifiedorder",
      ...>   execute_time: 1000,
      ...>   return_code: "SUCCESS",
      ...>   return_msg: "签名失败",
      ...>   result_code: "SUCCESS",
      ...>   err_code: "SYSTEMERROR",
      ...>   err_code_des: "系统错误",
      ...>   out_trade_no: "1217752501201407033233368018",
      ...>   user_ip: "8.8.8.8",
      ...>   time: "20091227091010"
      ...> }
      iex> WechatPay.API.Report.request(params)
      {:ok, data}
  """
  @spec request(map) :: {:ok, map} | {:error, WechatPay.Error.t | HTTPoison.Error.t}
  def request(params \\ %{}) do
    request_data =
      WechatPay.API.Report.RequestData
      |> struct(params)
      |> convert_execute_time

    Client.post_without_verify_sign(@api_path, request_data)
  end

  # Wechat will check presence of `execute_time_`,
  # but the doc is written as `execute_time`
  defp convert_execute_time(data) do
    {execute_time, data} = Map.pop(data, :execute_time)

    data
    |> Map.merge(%{execute_time_: execute_time})
  end

  defmodule RequestData do
    @moduledoc false

    defstruct [
      device_info: nil,
      interface_url: nil,
      execute_time: nil,
      return_code: nil,
      return_msg: nil,
      result_code: nil,
      err_code: nil,
      err_code_des: nil,
      out_trade_no: nil,
      user_ip: nil,
      time: nil
    ]
  end
end
