defmodule WechatPay.API.HTTPClient do
  @moduledoc false

  alias WechatPay.Client
  alias WechatPay.Utils.XMLBuilder
  alias WechatPay.Utils.XMLParser
  alias WechatPay.Utils.NonceStr
  alias WechatPay.Utils.Signature
  alias WechatPay.Error

  @doc """
  Send a POST request to Wehchat's Server
  """
  @spec post(Client.t(), String.t(), map, Keyword.t()) ::
          {:ok, map} | {:error, Error.t() | HTTPoison.Error.t()}
  def post(client, path, attrs, options) do
    path =
      client.api_host
      |> URI.merge(path)
      |> to_string()

    headers = [
      {"Accept", "application/xml"},
      {"Content-Type", "application/xml"}
    ]

    request_data =
      attrs
      |> append_ids(client.app_id, client.mch_id)
      |> generate_nonce_str
      |> sign(client.api_key)
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
  @spec download_text(Client.t(), String.t(), map, Keyword.t()) ::
          {:ok, String.t()} | {:error, HTTPoison.Error.t()}
  def download_text(client, path, data, options) do
    path =
      client.api_host
      |> URI.merge(path)
      |> to_string()

    headers = [
      {"Accept", "text/plain"},
      {"Content-Type", "application/xml"}
    ]

    request_data =
      data
      |> append_ids(client.app_id, client.mch_id)
      |> generate_nonce_str
      |> sign(client.api_key)
      |> XMLBuilder.to_xml()

    with {:ok, response} <- HTTPoison.post(path, request_data, headers, options) do
      {:ok, response.body}
    end
  end

  @doc false
  def generate_nonce_str(data) when is_map(data) do
    data
    |> Map.merge(%{nonce_str: NonceStr.generate()})
  end

  @doc false
  def sign(data, api_key) when is_map(data) do
    sign =
      data
      |> Signature.sign(api_key)

    data
    |> Map.merge(%{sign: sign})
  end

  defp append_ids(data, app_id, mch_id) when is_map(data) do
    data
    |> Map.merge(%{
      app_id: app_id,
      mch_id: mch_id
    })
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

  # handle return
  defp process_return_field(%{return_code: "SUCCESS"} = data) do
    {:ok, data}
  end

  defp process_return_field(%{return_code: "FAIL", return_msg: reason}) do
    {:error, %Error{reason: reason, type: :failed_return}}
  end

  defp process_return_field(%{retcode: _, retmsg: reason, return_code: "FAIL"}) do
    {:error, %Error{reason: reason, type: :failed_return}}
  end

  # handle result
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
