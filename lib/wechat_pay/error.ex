defmodule WechatPay.Error do
  @type t :: %__MODULE__{type: atom, reason: any}

  defexception [:reason, :type]

  def message(%__MODULE__{reason: reason, type: nil}), do: inspect(reason)
  def message(%__MODULE__{reason: reason, type: type}), do: "[Type: #{type}] - #{inspect(reason)}"
end
