defmodule WechatPay.Config do
  @moduledoc """
  Fetch application config

  ## Examples

    ```elixir
    use Mix.Config

    config :wechat_pay,
      env: :sandbox,
      appid: "wx8888888888888888",
      mch_id: "1900000109",
      apikey: "192006250b4c09247ec02edce69f6a2d"
    ```
  """

  @app_name :wechat_pay

  @doc """
  Fetch env from config, default is `:sandbox`, avaliable: `:sandbox` or `:production`
  """
  def env do
    get(:env, :sandbox)
  end

  @doc """
  Fetch App ID from config
  """
  def appid do
    get(:appid)
  end

  @doc """
  Fetch API Key from config
  """
  def apikey do
    get(:apikey)
  end

  @doc """
  Fetch Merchant ID from config
  """
  def mch_id do
    get(:mch_id)
  end

  defp get(key, default \\ nil) do
    case Application.get_env(@app_name, key, default) do
      nil ->
        raise err_msg_missing_config(key)
      value ->
        value
    end
  end

  defp err_msg_missing_config(key) when is_atom(key) do
    ~s"""
    The config #{key} for #{@app_name} is missing, Please config with:
      `config :#{@app_name}, #{key}: "value"`
    """
  end
end
