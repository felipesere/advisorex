defmodule Advisor.AdviceTest do
  use ExUnit.Case
  alias Advisor.{Advice, Answer}

  test "can figure out if an advice has been answered fully" do
    advice = %Advice{answers: [%Answer{}, %Answer{}, %Answer{}]}
    assert Advice.completed?(advice, 3)
  end

  test "can tell if advice has not been answered fully" do
    advice = %Advice{answers: [%Answer{}, %Answer{}]}
    refute Advice.completed?(advice, 3)
  end
end
