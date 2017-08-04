defmodule WechatPay.Helper do
  @moduledoc """
  Collection of helper functions
  """

  alias WechatPay.API.Client

  @doc """
  Fetch the Sandbox API Key

  where the `apikey` and `mch_id` is the **production** values.

  ## Example

  ```elixir
  iex> WechatPay.Helper.get_sandbox_signkey("wx8888888888888888", "1900000109")
  ...> {:ok, "the-key"}
  ```
  """
  @spec get_sandbox_signkey(
    String.t, String.t
  ) :: {:ok, String.t} | {:error, WechatPay.Error.t | HTTPoison.Error.t}
  def get_sandbox_signkey(apikey, mch_id) do
    case Client.get_sandbox_signkey(apikey, mch_id) do
      {:ok, %{sandbox_signkey: signkey}} ->
        {:ok, signkey}
      err -> err
    end
  end
end
