defmodule ElixirRotation.TaskMatcher do
  alias ElixirRotation.Matches
  alias ElixirRotation.Repo

  @doc """
  Runs a matching for the tasks and people of a collection and returns the result id.

  The result is stored as a `Matches.Match` and contains the associations and type of the match.

  ## Types of matches

  The following match types are supported:

  ### `:random_one`

  Assigns a random tasks to a random person.

  ### `:random_all`

  Assigns all tasks randomly to all persons. If they're
  more tasks then people the tasks are not assigned.

  ### `:random_all_fit`

  Assigns all tasks randomly to all persons. If they're
  more tasks then people some of them get multiple tasks.

  ### dependent matches

  Toggle if a future match is dependent on prior matches.
  For example a person matched in a prior match is only added
  back to the urn if all people are matched and a "new round"
  is started.

  """
  def match_tasks(collection, variation, dependent \\ true) do
    collection = Repo.preload(collection, [:people, :tasks])

    case variation do
      :random_one ->
        IO.puts("Choosing one random match")
        random_select_one(collection)
      :random_all_fit ->
        IO.puts("Choosing all random match with fit")
        random_select_all_fit(collection)
      :random_all ->
        IO.puts("Choosing all random match")
        random_select_all(collection)
      _ ->
        IO.puts("Algorithm variation unknown.")
    end
  end

  def random_select_one(collection) do
    task_id = 0 .. length(collection.tasks) - 1 |> Enum.random()
    person_id = 0 .. length(collection.people) - 1 |> Enum.random()
    %{task: Enum.at(collection.tasks, task_id),
      person: Enum.at(collection.people, person_id)}
  end

  def random_select_all(collection) do
  end

  def random_select_all_fit(collection) do
  end
end
