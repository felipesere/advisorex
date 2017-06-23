defmodule PageAssertions do
  use Phoenix.ConnTest
  import ExUnit.Assertions

  def has_title(html, expected_title) do
    assert html |> Floki.find("h1") |> Floki.text() == expected_title
    html
  end

  def has_feedback_questions(html, amount) do
    assert html |> Floki.find(".feedback-question") |> length == amount
    html
  end

  def has_answers(html, answers_to_look_for) do
    html
    |> Floki.find(".feedback-answer > blockquote")
    |> Enum.map(&Floki.text/1)
    |> Enum.each(&(assert Enum.member?(answers_to_look_for, &1)))
    html
  end
end
