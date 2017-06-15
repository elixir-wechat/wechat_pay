defmodule WechatPay.API.Client do
  @moduledoc """
  API Client
  """

  alias WechatPay.Config
  alias WechatPay.Utils.XMLBuilder
  alias WechatPay.Utils.XMLParser
  alias WechatPay.Utils.NonceStr
  alias WechatPay.Utils.Signature
  alias WechatPay.Error

  @sandbox_url "https://api.mch.weixin.qq.com/sandboxnew/"
  @production_url "https://api.mch.weixin.qq.com/"

  @doc """
  Post data
  """
  @spec post(String.t, map, keyword, boolean) :: {:ok, map} | {:error, Error.t | HTTPoison.Error.t}
  def post(path, data, options \\ [], verify_sign \\ true)
  def post(path, data, options, true) do
    with(
      {:ok, data} <- post(path, data, options, false),
      {:ok, data} <- verify_sign(data)
    ) do
      {:ok, data}
    end
  end
  def post(path, data, options, false) do
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

    with(
      {:ok, response} <- HTTPoison.post(path, request_data, headers, options),
      {:ok, response_data} <- process_response(response),
      {:ok, data} <- process_return_field(response_data),
      {:ok, data} <- process_result_field(data)
    ) do
      {:ok, data}
    end
  end

  @doc """
  Post data with SSL certs
  """
  @spec sec_post(String.t, map, keyword) :: {:ok, map} | {:error, Error.t | HTTPoison.Error.t}
  def sec_post(path, data, options \\ []) do
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
  @spec download_text(String.t, map, keyword) :: {:ok, String.t} | {:error, HTTPoison.Error.t}
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

    with {:ok, response} <- HTTPoison.post(path, request_data, headers, options) do
      {:ok, response.body}
    end
  end

  @doc """
  Get the Sandbox API key
  """
  @spec get_sandbox_signkey :: {:ok, String.t} | {:error, Error.t | HTTPoison.Error.t}
  def get_sandbox_signkey do
    path = @sandbox_url <> "pay/getsignkey"

    headers = [
      {"Accept", "text/plain"},
      {"Content-Type", "application/xml"}
    ]

    request_data =
      %{mch_id: Config.mch_id}
      |> generate_nonce_str
      |> sign
      |> XMLBuilder.to_xml

    with(
      {:ok, response} <- HTTPoison.post(path, request_data, headers),
      {:ok, response_data} <- process_response(response),
      {:ok, data} <- process_return_field(response_data)
    ) do
      {:ok, data}
    end
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

  defp process_response(%HTTPoison.Response{status_code: 200, body: body}) do
    body
    |> XMLParser.parse()
  end
  defp process_response(%HTTPoison.Response{status_code: 201, body: body}) do
    {:error, %Error{reason: body, type: :unprocessable_entity}}
  end
  defp process_response(%HTTPoison.Response{status_code: 404, body: body}) do
    {:error, %Error{reason: "The endpoint is not found", type: :not_found}}
  end
  defp process_response(%HTTPoison.Response{body: body}) do
    {:error, %Error{reason: body, type: :unknown_response}}
  end

  defp process_return_field(%{return_code: "SUCCESS"} = data) do
    {:ok, data}
  end
  defp process_return_field(%{return_code: "FAIL", return_msg: reason}) do
    {:error, %Error{reason: reason, type: :failed_return}}
  end

  defp process_result_field(%{result_code: "SUCCESS"} = data) do
    {:ok, data}
  end
  defp process_result_field(%{result_code: "FAIL", err_code: code, err_code_des: desc}) do
    {:error, %Error{reason: "Code: #{code}, msg: #{desc}", type: :failed_result}}
  end
  defp process_result_field(%{result_code: "FAIL", err_code: code, err_msg: desc}) do
    # sometimes the `err_code_des` is replaced by `err_msg`.
    process_result_field(%{result_code: "FAIL", err_code: code, err_code_des: desc})
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
      {:error, %Error{reason: "Invalid signature of wechat's response", type: :invalid_signature}}
    end
  end
end
