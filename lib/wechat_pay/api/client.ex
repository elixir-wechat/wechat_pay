defmodule WechatPay.API.Client do
  @moduledoc """
  The HTTP Client
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
  Send a POST request to Wehchat's Server
  """
  @spec post(String.t(), map, Keyword.t(), Config.t()) ::
          {:ok, map} | {:error, Error.t() | HTTPoison.Error.t()}
  def post(path, attrs, options, config) do
    case config.verify_sign do
      true ->
        do_post_with_verify_sign(path, attrs, options, config)

      false ->
        do_post_without_verify_sign(path, attrs, options, config)
    end
  end

  defp do_post_with_verify_sign(path, attrs, options, config) do
    with {:ok, data} <- do_post_without_verify_sign(path, attrs, options, config),
         :ok <- Signature.verify(data, config.apikey) do
      {:ok, data}
    end
  end

  defp do_post_without_verify_sign(path, attrs, options, config) do
    path = base_url(config) <> path

    headers = [
      {"Accept", "application/xml"},
      {"Content-Type", "application/xml"}
    ]

    request_data =
      attrs
      |> append_ids(config)
      |> generate_nonce_str
      |> sign(config.apikey)
      |> XMLBuilder.to_xml()

    with {:ok, response} <- HTTPoison.post(path, request_data, headers, options),
         {:ok, response_data} <- process_response(response),
         {:ok, data} <- process_return_field(response_data),
         {:ok, data} <- process_result_field(data) do
      {:ok, data}
    end
  end

  @doc """
  Download text data
  """
  @spec download_text(String.t(), map, Keyword.t(), Config.t()) ::
          {:ok, String.t()} | {:error, HTTPoison.Error.t()}
  def download_text(path, data, options, config) do
    path = base_url(config) <> path

    headers = [
      {"Accept", "text/plain"},
      {"Content-Type", "application/xml"}
    ]

    request_data =
      data
      |> append_ids(config)
      |> generate_nonce_str
      |> sign(config.apikey)
      |> XMLBuilder.to_xml()

    with {:ok, response} <- HTTPoison.post(path, request_data, headers, options) do
      {:ok, response.body}
    end
  end

  @doc """
  Get the Sandbox API key

  where the `apikey` and `mch_id` is the **production** values.
  """
  @spec get_sandbox_signkey(String.t(), String.t()) ::
          {:ok, map} | {:error, Error.t() | HTTPoison.Error.t()}
  def get_sandbox_signkey(apikey, mch_id) do
    path = @sandbox_url <> "pay/getsignkey"

    headers = [
      {"Accept", "text/plain"},
      {"Content-Type", "application/xml"}
    ]

    request_data =
      %{mch_id: mch_id}
      |> generate_nonce_str
      |> sign(apikey)
      |> XMLBuilder.to_xml()

    with {:ok, response} <- HTTPoison.post(path, request_data, headers),
         {:ok, response_data} <- process_response(response),
         {:ok, data} <- process_return_field(response_data) do
      {:ok, data}
    end
  end

  defp base_url(config) do
    case config.env do
      :sandbox ->
        @sandbox_url

      :production ->
        @production_url

      _ ->
        @sandbox_url
    end
  end

  defp append_ids(data, config) when is_map(data) do
    ids = %{
      appid: config.appid,
      mch_id: config.mch_id
    }

    Map.merge(data, ids)
  end

  defp generate_nonce_str(data) when is_map(data) do
    data
    |> Map.merge(%{nonce_str: NonceStr.generate()})
  end

  defp sign(data, apikey) when is_map(data) do
    sign =
      data
      |> Signature.sign(apikey)

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

  defp process_response(%HTTPoison.Response{status_code: 404, body: _body}) do
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
end
