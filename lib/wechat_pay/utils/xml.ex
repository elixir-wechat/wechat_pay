defmodule WechatPay.Utils.XML do
  @moduledoc false

  import Record, only: [defrecord: 2, extract: 2]

  defrecord :xml_element, extract(:xmlElement, from_lib: "xmerl/include/xmerl.hrl")
  defrecord :xml_text, extract(:xmlText, from_lib: "xmerl/include/xmerl.hrl")
end