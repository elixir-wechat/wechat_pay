defmodule WechatPay.Utils.XMLParser do
  @moduledoc false

  import SweetXml

  @doc """
  Convert a xml string to map
  """
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
