defmodule PageQueries do
  def requester(html) do
    html
    |> Floki.find(".progress-requester")
    |> Floki.text
  end

  def advisors(html) do
    html
    |> Floki.find(".advisor")
    |> Enum.map(&Floki.text/1)
  end
end
