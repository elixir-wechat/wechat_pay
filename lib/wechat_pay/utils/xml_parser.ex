defmodule WechatPay.Utils.XMLParser do
  @moduledoc """
  Module to convert a XML string to map
  """

  import SweetXml

  alias WechatPay.Error

  @doc """
  Convert a XML string to map
  """
  @spec parse(String.t) :: map
  def parse(data) when is_binary(data) do
    try do
      parsed_data =
        data
        |> xpath(~x"/xml/child::*"l)
        |> Enum.map(&parse_node/1)
        |> Enum.into(%{})

      {:ok, parsed_data}
    catch
      :exit, _ ->
        {:error, %Error{reason: "Malformed XML", type: :malformed_xml}}
    end
  end

  defp parse_node(node) do
    key =
      node
      |> xpath(~x"name(.)")
      |> List.to_atom

    value =
      node
      |> xpath(~x"./text()")
      |> String.Chars.to_string

    {key, value}
  end
end
