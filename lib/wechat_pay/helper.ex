defmodule WechatPay.Helper do
  @moduledoc false

  alias WechatPay.API.HTTPClient
  alias WechatPay.Utils.XMLParser
  alias WechatPay.Utils.XMLBuilder
  alias WechatPay.Error

  @doc """
  Get the Sandbox API Key

  where the `api_key` and `mch_id` is the **production** values.

  ## Example

  ```elixir
  iex> WechatPay.Helper.get_sandbox_signkey("wx8888888888888888", "1900000109")
  ...> {:ok, "the-key"}
  ```
  """
  @spec get_sandbox_signkey(String.t(), String.t()) ::
          {:ok, map} | {:error, Error.t() | HTTPoison.Error.t()}
  def get_sandbox_signkey(api_key, mch_id) do
    path =
      "https://api.mch.weixin.qq.com/sandboxnew/"
      |> URI.merge("pay/getsignkey")
      |> to_string()

    headers = [
      {"Accept", "text/plain"},
      {"Content-Type", "application/xml"}
    ]

    request_data =
      %{mch_id: mch_id}
      |> HTTPClient.generate_nonce_str()
      |> HTTPClient.sign(%{api_key: api_key, sign_type: :md5})
      |> XMLBuilder.to_xml()

    with {:ok, %HTTPoison.Response{status_code: 200, body: body}} <-
           HTTPoison.post(path, request_data, headers),
         {:ok, data} <- XMLParser.parse(body) do
      {:ok, data}
    end
  end
end
