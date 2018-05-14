defmodule WechatPay.Shared do
  @moduledoc false

  defmacro define_shared_behaviour(impl_module) do
    quote do
      impl_module = unquote(impl_module)

      @impl impl_module
      def place_order(attrs), do: WechatPay.API.place_order(attrs, config())

      @impl impl_module
      def query_order(attrs), do: WechatPay.API.query_order(attrs, config())

      @impl impl_module
      def close_order(attrs), do: WechatPay.API.close_order(attrs, config())

      @impl impl_module
      def refund(attrs), do: WechatPay.API.refund(attrs, config())

      @impl impl_module
      def query_refund(attrs), do: WechatPay.API.query_refund(attrs, config())

      @impl impl_module
      def download_bill(attrs), do: WechatPay.API.download_bill(attrs, config())

      @impl impl_module
      def report(attrs), do: WechatPay.API.report(attrs, config())
    end
  end
end
