defmodule FeatureToggle do
  def enabled(:emails, person) do
    allowed_emails =
      :advisor
      |> Application.get_env(FeatureToggle, [])
      |> Keyword.get(:emails, false)

    case allowed_emails do
      true -> true
      [only: names] -> person.name in names
      _else -> false
    end
  end
end
