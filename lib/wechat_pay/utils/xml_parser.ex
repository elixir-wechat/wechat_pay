defmodule WechatPay.Utils.XMLParser do
  @moduledoc """
  Module to convert a XML string to map
  """

  import SweetXml

  alias WechatPay.Error

  @doc """
  Convert the response XML string to map

  ## Example

  ```elixir
  iex> WechatPay.Utils.XMLParser.parse_response "<xml><foo><![CDATA[bar]]></foo></xml>"
  ...> {:ok, %{foo: "bar"}}
  ```
  """
  @spec parse_response(String.t) :: {:ok, map} | {:error, Error.t}
  def parse_response(data) when is_binary(data) do
    try do
      parsed_data =
        data
        |> xpath(~x"/xml/child::*"l)
        |> Enum.map(&parse_node/1)
        |> Enum.into(%{})

      {:ok, parsed_data}
    catch
      :exit, _ ->
        {:error, %Error{reason: "Malformed response XML", type: :malformed_response_xml}}
    end
  end

  @doc """
  Convert the decrypted XML string to map

  ## Example

  ```elixir
  iex> WechatPay.Utils.XMLParser.parse_decrypted "<root>\n<out_refund_no><![CDATA[foobar]]></out_refund_no>\n<out_trade_no><![CDATA[foobar]]></out_trade_no>\n</root>"
  ...> {:ok, %{out_refund_no: "foobar", out_trade_no: "foobar"}}
  ```
  """
  @spec parse_decrypted(String.t) :: {:ok, map} | {:error, Error.t}
  def parse_decrypted(data) when is_binary(data) do
    try do
      parsed_data =
        data
        |> xpath(~x"/root/child::*"l)
        |> Enum.map(&parse_node/1)
        |> Enum.into(%{})

      {:ok, parsed_data}
    catch
      :exit, _ ->
        {:error, %Error{reason: "Malformed decrypted XML", type: :malformed_decrypted_xml}}
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
