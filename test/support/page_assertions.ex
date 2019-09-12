defmodule PageAssertions do
  use Phoenix.ConnTest
  import ExUnit.Assertions

  def has_link_to(html, value) do
    links =
      html
      |> Floki.find("a")
      |> Enum.map(&Floki.text/1)

    assert value in links
    html
  end

  def has_no_link(html, value) do
    links =
      html
      |> Floki.find("a")
      |> Enum.map(&Floki.text/1)

    assert value not in links
    html
  end

  def has_links(html, values) do
    links =
      html
      |> Floki.find("a")
      |> Enum.map(&Floki.text/1)

    Enum.each(values, fn value -> assert value in links end)
    html
  end

  def has_title(html, expected_title) do
    assert html
           |> Floki.find("h1")
           |> Floki.text() =~ expected_title

    html
  end

  def has_advice_questions(html, amount) do
    assert html
           |> Floki.find("[data-testid=advice-question]")
           |> length == amount

    html
  end

  def has_see_advice_link(html) do
    assert html
           |> Floki.find(".see-advice-link")
           |> Floki.text()

    html
  end

  def has_links_to_advice(html, count) do
    assert html
           |> Floki.find("[data-testid=link-to-give-advice]")
           |> Enum.count() == count

    html
  end

  def has_answers(html, answers_to_look_for) do
    html
    |> Floki.find(".advice-answer > blockquote")
    |> Enum.map(&Floki.text/1)
    |> Enum.each(fn answer -> assert answer in answers_to_look_for end)

    html
  end

  def has_continue_button_with(html, text) do
    button =
      html
      |> Floki.find("button")
      |> Floki.text()

    assert button =~ text
    html
  end

  def has_completed_advice(html) do
    assert html
           |> Floki.find("[data-testid=completeness]")
           |> Enum.map(&Floki.text/1)
           |> Enum.any?(&(&1 =~ "Completed"))

    html
  end

  def has_header(html, header) do
    value =
      html
      |> Floki.find("h1")
      |> Floki.text()

    assert value == header
    html
  end

  def has_message(html, expected_message) do
    message =
      html
      |> Floki.find(".message")
      |> Floki.text()
      |> String.trim()

    assert message == expected_message
    html
  end

  def has_no_login(html) do
    assert html
           |> Floki.find(".login") == []

    html
  end

  def has_logout_button(html) do
    assert html
           |> Floki.find(".button.logout")
           |> length() == 1

    html
  end

  def has_submit_buttons(html, buttons) do
    assert html
           |> Floki.find("button[type=submit]")
           |> Enum.map(&Floki.text/1) == buttons

    html
  end
end
