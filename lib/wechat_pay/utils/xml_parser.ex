defmodule WechatPay.Utils.XMLParser do
  @moduledoc """
  Module to convert a XML string to map
  """

  import SweetXml

  @doc """
  Convert a XML string to map
  """
  @spec parse(String.t) :: map
  def parse(data) when is_binary(data) do
    data
    |> xpath(~x"/xml/child::*"l)
    |> Enum.map(fn(node) ->
      key =
        node
        |> xpath(~x"name(.)")
        |> List.to_atom

      value =
        node
        |> xpath(~x"./text()")
        |> String.Chars.to_string

      {key, value}
    end)
    |> Enum.into(%{})
  end
end
