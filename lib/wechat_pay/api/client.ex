defmodule WechatPay.API.Client do
  @moduledoc """
  API Client
  """

  alias WechatPay.Config
  alias WechatPay.Utils.XMLBuilder
  alias WechatPay.Utils.XMLParser
  alias WechatPay.Utils.NonceStr
  alias WechatPay.Utils.Signature

  @sandbox_url "https://api.mch.weixin.qq.com/sandbox/"
  @production_url "https://api.mch.weixin.qq.com/"

  def post(path, data, params \\ []) do
    path = base_url <> path

    headers = [
      {"Accept", "application/xml"},
      {"Content-Type", "application/xml"}
    ]

    request_data =
      data
      |> append_ids
      |> generate_nonce_str
      |> sign
      |> XMLBuilder.to_xml

    response = HTTPoison.post!(path, request_data, headers, params)

    response_data =
      response.body
      |> XMLParser.parse()

    with {:ok, data} <- process_connection_result(response_data),
      {:ok, data} <- process_business_result(data),
      {:ok, data} <- verify_sign(data)
    do
      {:ok, data}
    else
      err -> err
    end
  end

  def download_text(path, data, params \\ []) do
    path = base_url <> path

    headers = [
      {"Accept", "text/plain"},
      {"Content-Type", "application/xml"}
    ]

    request_data =
      data
      |> append_ids
      |> generate_nonce_str
      |> sign
      |> XMLBuilder.to_xml

    response = HTTPoison.post!(path, request_data, headers, params)

    {:ok, response.body}
  end

  defp base_url do
    case Config.env do
      :sandbox ->
        @sandbox_url
      :production ->
        @production_url
      _ ->
        @sandbox_url
    end
  end

  defp append_ids(data) when is_map(data) do
    ids =
      %{
        appid: Config.appid,
        mch_id: Config.mch_id,
      }

    Map.merge(data, ids)
  end

  defp generate_nonce_str(data) when is_map(data) do
    data
    |> Map.merge(%{nonce_str: NonceStr.generate})
  end

  defp sign(data) when is_map(data) do
    sign =
      data
      |> Signature.sign

    data
    |> Map.merge(%{sign: sign})
  end

  defp process_connection_result(%{return_code: "SUCCESS"} = data) do
    {:ok, data}
  end
  defp process_connection_result(%{return_code: "FAIL", return_msg: reason}) do
    {:error, reason}
  end

  defp process_business_result(%{result_code: "SUCCESS"} = data) do
    {:ok, data}
  end
  defp process_business_result(%{result_code: "FAIL", err_code: code, err_msg: desc}) do
    wechat_error_code_page_url = "http://wxpay.weixin.qq.com/errcode/index.php?interface=&errCode=&errReason="
    {:error, "Code: #{code}, msg: #{desc}, detail: #{wechat_error_code_page_url}"}
  end
  defp process_business_result(%{result_code: "FAIL", err_code: code, err_code_des: desc}) do
    wechat_error_code_page_url = "http://wxpay.weixin.qq.com/errcode/index.php?interface=&errCode=&errReason="
    {:error, "Code: #{code}, msg: #{desc}, detail: #{wechat_error_code_page_url}"}
  end

  defp verify_sign(data) do
    sign = data.sign

    calculated =
      data
      |> Map.delete(:sign)
      |> Signature.sign()

    if sign == calculated do
      {:ok, data}
    else
      {:error, "invalid signature of wechat's response"}
    end
  end
end
