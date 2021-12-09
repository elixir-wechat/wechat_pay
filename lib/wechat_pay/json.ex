defmodule WechatPay.JSON do
  @moduledoc """
  The module act as an adapter to JSON library.

  By default, it use `Jason` to encode JSON, if you want to use `Poison`,
  you can configure `:wechat_pay` application with:

  ```elixir
  config :wechat_pay, :json_library, Poison
  ```
  """

  json_lib =
    case Application.get_env(:wechat_pay, :json_library, Jason) do
      lib when lib in [Jason, Poison] ->
        lib

      other ->
        IO.warn("""
        You has set the JSON Library to `#{other}`, which might not work as expected.

        Currently, only `Jason` and `Poison` are supported,
        you can config it with:

            config :wechat_pay, :json_library, Jason
        """)

        other
    end

  @json_lib json_lib

  @doc false
  defmacro encode!(value) do
    quote do
      unquote(@json_lib).encode!(unquote(value))
    end
  end
end
