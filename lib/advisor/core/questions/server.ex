defmodule Advisor.Core.Questions.Server do
  use GenServer
  alias Advisor.Core.Questions.YamlQuestions

  def from_content(data) do
    {:ok, _pid} = GenServer.start_link(__MODULE__, YamlQuestions.from_data(data), name: __MODULE__)
  end

  def from_file(path) do
    {:ok, _pid} = GenServer.start_link(__MODULE__, YamlQuestions.all(path), name: __MODULE__)
  end

  def handle_call(:all, _from, yaml) do
    {:reply, yaml, yaml}
  end

  def handle_call({:find, ids}, _from, yaml) do
    {:reply, YamlQuestions.find(yaml, ids), yaml}
  end

  def all() do
    GenServer.call(__MODULE__, :all)
  end

  def find(ids) do
    GenServer.call(__MODULE__, {:find, ids})
  end

  def phrases(questions) do
    YamlQuestions.phrases(questions)
  end

  def stop() do
    GenServer.stop(__MODULE__)
  end
end
