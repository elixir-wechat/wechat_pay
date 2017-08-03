defmodule TestCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      use ExUnit.Case, async: false
    end
  end

  setup do
    config = Application.get_env(:wechat_pay, MyPay)

    [config: config]
  end
end
