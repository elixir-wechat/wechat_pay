defmodule WechatPay.Client do
  @moduledoc """
  API client.
  """

  alias WechatPay.Client

  @enforce_keys [:app_id, :mch_id, :api_key]
  defstruct api_host: "https://api.mch.weixin.qq.com/",
            app_id: nil,
            mch_id: nil,
            api_key: nil,
            sign_type: :md5,
            ssl: nil

  @type t :: %Client{
          api_host: String.t(),
          app_id: String.t(),
          mch_id: String.t(),
          api_key: String.t(),
          sign_type: :md5 | :sha256,
          ssl: [
            {:ca_cert, String.t() | nil},
            {:cert, String.t()},
            {:key, String.t()}
          ]
        }

  @doc """
  Build a new Config from keyword list
  """
  @spec new(Enum.t()) :: Client.t()
  def new(opts) do
    struct(Client, opts)
  end
end
