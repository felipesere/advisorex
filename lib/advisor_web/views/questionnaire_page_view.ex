defmodule AdvisorWeb.QuestionnairePageView do
  use AdvisorWeb, :view

  def image_url(person) do
    if person.profile_image == "" do
      "https://maxcdn.icons8.com/Share/icon/p1em/Users//user1600.png"
    else
      person.profile_image
    end
  end
end
