defmodule Advisor.Core.Questions.PhraseKind do
  def to_i(:technical), do: 1
  def to_i(:client),    do: 2
  def to_i(:community), do: 3
end
