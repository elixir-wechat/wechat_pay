defmodule Mix.Tasks.WechatPay.GetSandboxSignkey do
  @moduledoc """
  Get WechatPay's Sandbox API Key

  ## Example

  ```shell
  $ mix wechat_pay.get_sandbox_signkey -a wx8888888888888888 -m 1900000109
  af11b9e92929e3f6d3847d7a291d5f64
  ```

  ## Command line options

  - `-a`, `--api_key` - the production API key
  - `-m`, `--mch_id` - the merchant ID
  """

  use Mix.Task

  @shortdoc "Get WechatPay's Sandbox API Key"

  @impl Mix.Task
  @spec run([binary()]) :: any()
  def run(args) do
    {:ok, _} = Application.ensure_all_started(:wechat_pay)

    {opts, _} =
      args
      |> OptionParser.parse!(
        aliases: [a: :api_key, m: :mch_id],
        strict: [api_key: :string, mch_id: :string]
      )

    case WechatPay.Helper.get_sandbox_signkey(
           get_value(opts, :api_key),
           get_value(opts, :mch_id)
         ) do
      {:ok, key} ->
        Mix.shell().info(inspect(key))

      {:error, any} ->
        Mix.shell().error(inspect(any))
    end
  end

  defp get_value(opts, key) do
    case Keyword.get(opts, key) do
      nil ->
        Mix.shell().error("Please specific the #{key} with `--#{key}`")
        exit({:shutdown, 1})

      v ->
        v
    end
  end
end
