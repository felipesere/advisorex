ExUnit.configure(formatters: [ExUnit.CLIFormatter, ExUnitNotifier], exclude: [pending: true])
ExUnit.start()

Ecto.Adapters.SQL.Sandbox.mode(Advisor.Repo, :manual)
