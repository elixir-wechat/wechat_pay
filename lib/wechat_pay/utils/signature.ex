defmodule WechatPay.Utils.Signature do
  @moduledoc false

  alias WechatPay.Config

  @doc """
  Sign data

  Returns signed data.
  """
  def sign(data) when is_map(data) do
    sign =
      data
      |> Map.delete(:__struct__)
      |> Enum.sort
      |> Enum.map(&process_param/1)
      |> Enum.reject(&(is_nil(&1)))
      |> List.insert_at(-1, "key=#{Config.apikey}")
      |> Enum.join("&")

    :crypto.hash(:md5, sign)
    |> Base.encode16
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
