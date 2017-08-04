defmodule Mix.Tasks.WechatPay.GetSandboxSignkey do
  @moduledoc """
  Get WechatPay's Sandbox API Key

  ## Example

  ```elixir
  mix wechat_pay.get_sandbox_signkey -a wx8888888888888888 -m 1900000109
  ```

  ## Command line options

  - `-a`, `--apikey` - the production API key
  - `-m`, `--mch_id` - the merchant ID
  """

  use Mix.Task

  @shortdoc "Get WechatPay's Sandbox API Key"

  def run(args) do
    {:ok, _} = Application.ensure_all_started(:wechat_pay)

    {opts, _, _} =
      args
      |> OptionParser.parse(
        aliases: [a: :apikey, m: :mch_id],
        strict: [apikey: :string, mch_id: :string]
      )

    case WechatPay.Helper.get_sandbox_signkey(Keyword.get(opts, :apikey), Keyword.get(opts, :mch_id)) do
      {:ok, key} -> Mix.shell.info(key)
      {:error, err} -> Mix.shell.error(inspect(err))
    end
  end
end
