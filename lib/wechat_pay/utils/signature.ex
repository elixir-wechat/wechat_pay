defmodule WechatPay.Utils.Signature do
  @moduledoc """
  Module to sign data
  """

  alias WechatPay.Error
  alias WechatPay.JSON

  require JSON

  @doc """
  Generate the signature of data with API key

  ## Example

  ```elixir
  iex> WechatPay.Utils.Signature.sign(%{...}, "wx9999")
  ...> "02696FC7E3E19F852A0335F2F007DD3E"
  ```
  """
  @spec sign(map, String.t(), :md5 | :sha256) :: String.t()
  def sign(data, api_key, :md5) when is_map(data) do
    sign_string = generate_sign_string(data, api_key)

    :md5
    |> :crypto.hash(sign_string)
    |> Base.encode16()
  end

  def sign(data, api_key, :sha256) when is_map(data) do
    sign_string = generate_sign_string(data, api_key)

    # :crypto.sign(:rsa, :sha256, sign_string, api_key)
    :sha256
    |> :crypto.hmac(api_key, sign_string)
    |> Base.encode16()
  end

  def sign(data, api_key, _other) when is_map(data) do
    sign(data, api_key, :md5)
  end

  @doc """
  Verify the signature of Wechat's response

  ## Example

  ```elixir
  iex > WechatPay.Utils.Signature.verify(%{sign: "foobar"}, "a45a313dfbf0494288c3e56bcacf30daa")
  ... > :ok
  ```
  """
  @spec verify(map, String.t(), :md5 | :sha256) :: :ok | {:error, Error.t()}
  def verify(data, api_key, sign_type) when is_map(data) do
    calculated =
      data
      |> Map.delete(:sign)
      |> sign(api_key, sign_type)

    if data.sign == calculated do
      :ok
    else
      {:error, %Error{reason: "Invalid signature of wechat's response", type: :invalid_signature}}
    end
  end

  defp process_param({_k, ""}) do
    nil
  end

  defp process_param({_k, nil}) do
    nil
  end

  defp process_param({k, v}) when is_map(v) do
    "#{k}=#{JSON.encode!(v)}"
  end

  defp process_param({k, v}) do
    "#{k}=#{v}"
  end

  defp generate_sign_string(data, api_key) do
    data
    |> Map.delete(:__struct__)
    |> Enum.sort()
    |> Enum.map(&process_param/1)
    |> Enum.reject(&is_nil/1)
    |> List.insert_at(-1, "key=#{api_key}")
    |> Enum.join("&")
  end
end
