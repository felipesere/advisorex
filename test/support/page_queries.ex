defmodule PageQueries do
  def mentee(html) do
    html
    |> Floki.find(".progress-mentee")
    |> Floki.text()
  end

  def advisors(html) do
    html
    |> Floki.find(".advisor")
    |> Enum.map(&Floki.text/1)
  end
end
