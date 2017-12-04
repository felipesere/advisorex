defmodule Advisor.Core.SummaryTest do
  use Advisor.DataCase

  alias Advisor.Test.Support.Sample
  alias Advisor.Core.Summary

  test "presents tabular data for a given questionnaire" do
    questionnaire = Sample.questionnaire()
    Sample.answer(questionnaire, all: "foo")

    [headers, first, _second] = Summary.for_download(questionnaire.id)
    assert length(headers) == length(first)
  end
end
