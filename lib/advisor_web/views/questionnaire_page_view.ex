defmodule AdvisorWeb.QuestionnairePageView do
  use AdvisorWeb, :view

  def image_url(person) do
    if person.profile_image == "" do
      "https://secure.gravatar.com/avatar/#{hash_email(person.email)}?s=250"
    else
      person.profile_image
    end
  end

  defp hash_email(email) do
    :crypto.hash(:md5, String.downcase(email))
    |> Base.encode16(case: :lower)
  end
end
