defmodule WechatPay.API.JSONTest do
  use TestCase, async: true

  alias WechatPay.JSON
  require JSON

  test "encode JSON" do
    assert "{\"some\":\"value\"}" == JSON.encode!(%{some: "value"})
  end
end
