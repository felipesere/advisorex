defmodule AdvisorWeb.QuestionnairePageView do
  use AdvisorWeb, :view

  def image_url(person) do
    if person.profile_image == "" do
      gravatar_url(person.email)
    else
      person.profile_image
    end
  end

  defp gravatar_url(email) do
    "https://secure.gravatar.com/avatar/#{hash_email(email)}?s=250"
  end

  defp hash_email(email) do
    email
    |> String.downcase()
    |> md5()
    |> Base.encode16(case: :lower)
  end

  def md5(value), do: :crypto.hash(:md5, value)
end
