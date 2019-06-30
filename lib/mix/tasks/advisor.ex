defmodule Mix.Tasks.Advisor do
  use Mix.Task

  @shortdoc "Interact with the API on prod"

  @local "http://localhost:4000"
  @prod  "https://advisorex.herokuapp.com"

  def run(params) do
    {:ok, _} = Application.ensure_all_started(:hackney)

    handle(params, :prod)
  end

  def handle(["--local" | rest], _) do
    handle(rest, :local)
  end

  def handle(["show", "questionnaires" | _], opts) do
    {:ok, questionnaires} = request(:get, "/admin/questionnaires", opts)

    Scribe.print(questionnaires, data: ["id", "mentor", "mentee", {"advisors", fn %{"advisors" => a} -> Enum.join(a, ", ") end}])
  end

  def handle(["show", "people" | _], opts) do
    {:ok, people} = request(:get, "/admin/people", opts)
    Scribe.print(people, data: ["name", "email", "is_mentor"])
  end

  def handle(["delete", "person", email | _], opts) do
    {:ok, _} = request(:delete, "/admin/people/#{email}", opts)
    IO.puts "Done"
  end

  def request(verb, resource, opts) do
    base = base(opts)

    {:ok, status, _, client_ref} = :hackney.request(verb, base <> resource, headers())

    case status do
      401 -> {:error, :unauthorized}
      404 -> {:error, :not_found}
      _ -> read_body(client_ref)
    end

  end

  def base(:prod), do: @prod
  def base(:local), do: @local

  def read_body(client) do
    with {:ok, body} <- :hackney.body(client),
         {:ok, data} <- Jason.decode(body)
      do
      {:ok, data}
    else
      _ -> {:ok, ""}
    end
  end

  def headers() do
    token = System.get_env("ADVISOR_ADMIN_API_KEY")
    [{"Authorization", "Bearer #{token}"}]
  end
end
