defmodule WechatPay.Utils.XMLBuilder do
  @moduledoc """
  Module to convert a map to XML string
  """

  @doc """
  Convert a map to XML string

  ## Example

  ```elixir
  iex> WechatPay.Utils.XMLBuilder.to_xml(%{foo: "bar"})
  ...> "<xml><foo><![CDATA[bar]]></foo></xml>"
  ```
  """
  @spec to_xml(map) :: String.t
  def to_xml(data) when is_map(data) do
    data
    |> Map.to_list()
    |> Keyword.delete(:__struct__)
    |> Enum.map(&build_node/1)
    |> Enum.join()
    |> wrap_xml
  end

  defp build_node({_key, nil}) do
    # ignore nil values
  end
  defp build_node({key, value}) when is_map(value) do
    "<#{key}><![CDATA[#{Poison.encode!(value)}]]></#{key}>"
  end
  defp build_node({key, value}) when is_binary(value) do
    "<#{key}><![CDATA[#{value}]]></#{key}>"
  end
  defp build_node({key, value}) when is_integer(value) do
    "<#{key}><![CDATA[#{value}]]></#{key}>"
  end

  defp wrap_xml(string) do
    "<xml>#{string}</xml>"
  end
end
