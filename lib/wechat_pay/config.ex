defmodule WechatPay.Config do
  @moduledoc """
  Fetch application config
  """

  alias WechatPay.Config.Helper

  @app_name :wechat_pay

  # follows same naming convention with Wechat's API
  @func_names ~w(appid apikey mch_id)a
  Enum.each @func_names, fn k ->
    def unquote(k)(), do: get(unquote(k))
  end

  def env do
    get(:env, :sandbox)
  end

  defp get(key, default \\ nil) do
    case Helper.get(@app_name, key, default) do
      nil ->
        raise err_msg_missing_config(key)
      value ->
        value
    end
  end

  defp err_msg_missing_config(key) when is_atom(key) do
    env_prefix =
      @app_name
      |> Atom.to_string
      |> String.upcase

    env_suffix =
      key
      |> Atom.to_string
      |> String.upcase

    ~s"""
    The config #{key} for #{@app_name} is missing, Please config with:
      `config :#{@app_name}, #{key}: "value"` or
      `config :#{@app_name}, #{key}: {:system, "#{env_prefix}_#{env_suffix}"}`
    """
  end

  defmodule Helper do
    @moduledoc """
    This module handles fetching values from the config with some additional niceties

    Credit: https://gist.github.com/bitwalker/a4f73b33aea43951fe19b242d06da7b9
    """

    @doc """
    Fetches a value from the config, or from the environment if {:system, "VAR"}
    is provided.
    An optional default value can be provided if desired.
    ## Example
        iex> {test_var, expected_value} = System.get_env |> Enum.take(1) |> List.first
        ...> Application.put_env(:myapp, :test_var, {:system, test_var})
        ...> ^expected_value = #{__MODULE__}.get(:myapp, :test_var)
        ...> :ok
        :ok
        iex> Application.put_env(:myapp, :test_var2, 1)
        ...> 1 = #{__MODULE__}.get(:myapp, :test_var2)
        1
        iex> :default = #{__MODULE__}.get(:myapp, :missing_var, :default)
        :default
    """
    @spec get(atom, atom, term | nil) :: term
    def get(app, key, default \\ nil) when is_atom(app) and is_atom(key) do
      case Application.get_env(app, key) do
        {:system, env_var} ->
          case System.get_env(env_var) do
            nil -> default
            val -> val
          end
        {:system, env_var, preconfigured_default} ->
          case System.get_env(env_var) do
            nil -> preconfigured_default
            val -> val
          end
        nil ->
          default
        val ->
          val
      end
    end
  end
end
