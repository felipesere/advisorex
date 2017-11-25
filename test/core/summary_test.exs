defmodule Advisor.Core.SummaryTest do
  use Advisor.DataCase

  alias Advisor.Test.Support.Sample
  alias Advisor.Core.{Advice, Summary}

  test "presents tabular data for a given questionnaire" do
    questionnaire = Sample.questionnaire()
    advisories = Advice.find_all(questionnaire)

    ThroughTheCore.answer!(advisories, with: %{"1" => "Foo", "2" => "Bar"})

    [_headers, columns, _second] = Summary.for_download(questionnaire.id)
    assert length(columns) == 5
  end
end
