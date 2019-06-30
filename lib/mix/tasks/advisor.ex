defmodule Mix.Tasks.Advisor do
  use Mix.Task

  @shortdoc "Interact with the API on prod"

  @local "http://localhost:4000"
  @prod  "https://advisorex.herokuapp.com"

  def run(params) do
    {:ok, _} = Application.ensure_all_started(:hackney)

    handle(params, [to: :prod])
  end

  def handle(["--local" | rest], _) do
    handle(rest, [to: :local])
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

  def handle(["create", "person" | params], opts) do
    person =
      params
      |> Enum.chunk_every(2)
      |> Enum.into(%{}, fn [field, value] -> {String.replace(field, "--", ""), value} end)

    {:ok, _} = request(:post, "/admin/people", [{:payload, person} | opts])
    IO.puts "created"
  end

  def request(verb, resource, opts) do
    base = base(opts)
    body = body_of(opts)
           |> IO.inspect

    {:ok, status, _, client_ref} = :hackney.request(verb, base <> resource, headers(opts), body, [])

    case status do
      401 -> {:error, :unauthorized}
      404 -> {:error, :not_found}
      _ -> read_body(client_ref)
    end

  end

  def base(opts) do
    case Keyword.fetch!(opts, :to) do
      :prod -> @prod
      :local -> @local
    end
  end

  def body_of(opts) do
    case Keyword.get(opts, :payload) do
      nil -> []
      {:ok, data} -> Jason.encode!(data)
    end
  end

  def read_body(client) do
    with {:ok, body} <- :hackney.body(client),
         {:ok, data} <- Jason.decode(body)
      do
      {:ok, data}
    else
      _ -> {:ok, ""}
    end
  end

  def headers(opts), do: auth() ++ content_type(opts)

  defp auth() do
    token = System.get_env("ADVISOR_ADMIN_API_KEY")
    [{"Authorization", "Bearer #{token}"}]
  end

  defp content_type(opts) do
    has_payload = Keyword.get(opts, :payload)

    if has_payload do
      [{"Content-Type", "application/json"}]
    else
      []
    end
  end
end
