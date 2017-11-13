defmodule AdvisorWeb.QuestionnairePageView do
  use AdvisorWeb, :view
  alias Advisor.Core.Gravatar

  def image_url(person) do
    if person.profile_image == "" do
      Gravatar.url(person.email)
    else
      person.profile_image
    end
  end
end
