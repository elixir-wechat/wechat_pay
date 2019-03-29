defmodule TestCase do
  use ExUnit.CaseTemplate

  alias WechatPay.Client

  using do
    quote do
      use ExUnit.Case, async: false
    end
  end

  setup do
    config = Application.get_env(:wechat_pay, TestPay)

    {:ok, client} = Client.new(config)

    [client: client]
  end
end
