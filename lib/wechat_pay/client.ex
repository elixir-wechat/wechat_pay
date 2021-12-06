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

  @sign_types [:md5, :sha256]

  @doc """
  Build a new client from options.

  ## Example

      iex>WechatPay.Client.new(app_id: "APP_ID", mch_id: "MCH_ID", api_key: "API_KEY", sign_type: :sha256)
      {:ok,
      %WechatPay.Client{
        api_host: "https://api.mch.weixin.qq.com/",
        api_key: "API_KEY",
        app_id: "APP_ID",
        mch_id: "MCH_ID",
        sign_type: :sha256,
        ssl: nil
      }}
  """
  @spec new(Enum.t()) :: {:ok, Client.t()} | {:error, binary()}
  def new(opts) do
    attrs = Enum.into(opts, %{})

    with :ok <- validate_opts(attrs),
         client = struct(Client, attrs) do
      {:ok, client}
    end
  end

  @enforce_keys
  |> Enum.each(fn key ->
    defp unquote(:"validate_#{key}")(%{unquote(key) => value}) when not is_nil(value) do
      :ok
    end

    defp unquote(:"validate_#{key}")(_) do
      {:error, "please set `#{unquote(key)}`"}
    end
  end)

  defp validate_sign_type(%{sign_type: sign_type}) when sign_type in @sign_types do
    :ok
  end

  defp validate_sign_type(%{sign_type: sign_type}) do
    {:error,
     "`#{sign_type}` is invalid for `sign_type`, available options: `:md5` and `:sha256`."}
  end

  defp validate_sign_type(_) do
    :ok
  end

  defp validate_opts(attrs) when is_map(attrs) do
    with :ok <- validate_app_id(attrs),
         :ok <- validate_mch_id(attrs),
         :ok <- validate_api_key(attrs),
         :ok <- validate_sign_type(attrs) do
      :ok
    end
  end
end
