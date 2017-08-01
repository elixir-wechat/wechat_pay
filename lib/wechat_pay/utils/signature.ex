defmodule WechatPay.Utils.Signature do
  @moduledoc """
  Module to sign data
  """

  alias WechatPay.Error

  @doc """
  Generate the signature of data with API key
  """
  @spec sign(map, String.t) :: String.t
  def sign(data, apikey) when is_map(data) do
    sign =
      data
      |> Map.delete(:__struct__)
      |> Enum.sort
      |> Enum.map(&process_param/1)
      |> Enum.reject(&is_nil/1)
      |> List.insert_at(-1, "key=#{apikey}")
      |> Enum.join("&")

    :md5
    |> :crypto.hash(sign)
    |> Base.encode16
  end

  @doc """
  Verify the signature of Wechat's response
  """
  @spec verify(map, String.t) :: :ok | {:error, Error.t}
  def verify(data, apikey) when is_map(data) do
    calculated =
      data
      |> Map.delete(:sign)
      |> sign(apikey)

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
    "#{k}=#{Poison.encode!(v)}"
  end
  defp process_param({k, v}) do
    "#{k}=#{v}"
  end
end
