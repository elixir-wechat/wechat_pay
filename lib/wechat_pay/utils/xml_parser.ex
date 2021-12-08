defmodule WechatPay.Utils.XMLParser do
  @moduledoc """
  Module to convert a XML string to map
  """
  require WechatPay.Utils.XML

  alias WechatPay.Utils.XML
  alias WechatPay.Error

  @doc """
  Convert the response XML string to map

  ## Example

  ```elixir
  iex> WechatPay.Utils.XMLParser.parse("<xml><foo><![CDATA[bar]]></foo></xml>", "xml")
  ...> {:ok, %{foo: "bar"}}

  iex> WechatPay.Utils.XMLParser.parse("<root><foo><![CDATA[bar]]></foo></root>", "root")
  ...> {:ok, %{foo: "bar"}}
  ```
  """
  @spec parse(String.t(), String.t()) :: {:ok, map} | {:error, Error.t()}
  def parse(xml_string, root_element \\ "xml") when is_binary(xml_string) do
    try do
      {doc, _} =
        xml_string
        |> :binary.bin_to_list()
        |> :xmerl_scan.string(quiet: true)

      parsed_xml = extract_doc(doc, root_element)

      {:ok, parsed_xml}
    catch
      :exit, _ ->
        {:error,
         %Error{
           reason: "Malformed XML, requires root element: #{root_element}",
           type: :malformed_xml
         }}
    end
  end

  defp extract_doc(doc, root) do
    "/#{root}/child::*"
    |> String.to_charlist()
    |> :xmerl_xpath.string(doc)
    |> Enum.into(%{}, &extract_element/1)
  end

  defp extract_element(element) do
    name = XML.xml_element(element, :name)

    [content] = XML.xml_element(element, :content)

    value =
      content
      |> XML.xml_text(:value)
      |> String.Chars.to_string()

    {name, value}
  end
end
