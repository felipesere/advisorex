ExUnit.configure(formatters: [ExUnit.CLIFormatter], exclude: [pending: true])
ExUnit.start()

Ecto.Adapters.SQL.Sandbox.mode(Advisor.Repo, :manual)
