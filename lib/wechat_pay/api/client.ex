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

  @doc """
  Post data
  then verify the connection & business result,
  then verify the sign.
  """
  @spec post(String.t, map, keyword) :: {:ok, map} | {:error, any}
  def post(path, data, options \\ []) do
    path = base_url() <> path

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

    response = HTTPoison.post!(path, request_data, headers, options)

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

  @doc """
  Post data
  then verify the connection & business result.
  """
  @spec post_without_verify_sign(String.t, map, keyword) :: {:ok, map} | {:error, any}
  def post_without_verify_sign(path, data, options \\ []) do
    path = base_url() <> path

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

    response = HTTPoison.post!(path, request_data, headers, options)

    response_data =
      response.body
      |> XMLParser.parse()

    with {:ok, data} <- process_connection_result(response_data),
      {:ok, data} <- process_business_result(data)
    do
      {:ok, data}
    else
      err -> err
    end
  end

  @doc """
  Post data with SSL certs,
  then verify the connection & business result,
  then verify the sign.
  """
  @spec ssl_post(String.t, map, keyword) :: {:ok, map} | {:error, any}
  def ssl_post(path, data, options \\ []) do
    secure_options = [
      hackney: [ # :hackney options
        ssl_options: [ # :ssl options
          cacertfile: Config.ssl_cacertfile,
          certfile: Config.ssl_certfile,
          keyfile: Config.ssl_keyfile,
          password: String.to_charlist(Config.ssl_password)
        ]
      ]
    ]
    post(path, data, Keyword.merge(secure_options, options))
  end

  @doc """
  Download text data
  """
  @spec download_text(String.t, map, keyword) :: {:ok, String.t}
  def download_text(path, data, options \\ []) do
    path = base_url() <> path

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

    response = HTTPoison.post!(path, request_data, headers, options)

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
  defp process_business_result(%{result_code: "FAIL", err_code: code, err_code_des: desc}) do
    {:error, "Code: #{code}, msg: #{desc}, detail: http://wxpay.weixin.qq.com/errcode/index.php?interface=&errCode=#{code}&errReason="}
  end
  defp process_business_result(%{result_code: "FAIL", err_code: code, err_msg: desc}) do
    process_business_result(%{result_code: "FAIL", err_code: code, err_code_des: desc})
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
