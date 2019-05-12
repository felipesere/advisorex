defmodule Advisor.Core.Dashboard.MentorSection do
  alias Advisor.Core.{Person, Questionnaire}

  defstruct groups: []

  defmodule Group do
    defstruct [:questionnaire_id, :mentee, :advisors]
  end

  def mentor_section(%Person{is_mentor: false}) do
    %__MODULE__{groups: []}
  end

  def mentor_section(%Person{is_mentor: true, id: mentor}) do
    mentor
    |> Questionnaire.all_for_mentor()
    |> Enum.map(&to_group/1)
    |> to_section()
  end

  defp to_section(groups) do
    %__MODULE__{groups: groups}
  end

  defp to_group(%{id: id} = questionnaire) do
    %Group{
      questionnaire_id: id,
      mentee: questionnaire.mentee,
      advisors: all_advisors(questionnaire)
    }
  end

  defp all_advisors(%{advice: advice}), do: Enum.map(advice, fn a -> a.advisor end)
end
