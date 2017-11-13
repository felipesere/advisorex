defmodule Advisor.Core.GravatarTest do
  use ExUnit.Case
  alias Advisor.Core.Gravatar

  test "creates a Gravatar URL" do
    assert Gravatar.url("MyEmailAddress@example.com ") == "https://secure.gravatar.com/avatar/28649e6deeab266661fd0e92425669d0?s=250"
  end
end
