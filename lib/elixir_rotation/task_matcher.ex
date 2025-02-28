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
  def match_tasks(collection) do
    collection = Repo.preload(collection, [:people, :tasks])

    case collection.algorithm do
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

  @doc """
  Returns an assignment of one random person one random tasks.

  If the collection has the key `put_back` set to false only
  people and tasks are chosen which are not already taken in a prior
  match. The element is re-taken into the selection after all elements
  from the category (people, tasks) are used in the round.
  """
  def random_select_one(collection) do
    round = get_current_round(collection)

    if collection.put_back do
      task_pos = 0..(length(collection.tasks) - 1) |> Enum.random()
      task = Enum.at(collection.tasks, task_pos)
      person_pos = 0..(length(collection.people) - 1) |> Enum.random()
      person = Enum.at(collection.people, person_pos)

      %{
        assignment: %{person.id => [task.id]},
        tasks: [task],
        people: [person],
        round: round + 1
      }
    else
      # Get people defined in collection.
      collection_people = collection.people
      # Get all previous matches
      matches = Matches.list_collection_matches(collection)

      # Get the list of all people
      people = Enum.flat_map(matches, fn m -> m.people end)

      # Calculate the distribution of all people names
      people_distribution = Enum.frequencies_by(people, & &1.name)

      %{assignment: %{}, tasks: [], people: [], round: round + 1}
    end
  end

  @doc """
  Returns an assignment pairing all people with all tasks.

  If they're more people than tasks only a subset of people
  get a task assigned.
  If they're more tasks than people the remaining tasks
  are randomly assigned between all people.
  """
  def random_select_all(collection) do
    round = get_current_round(collection)
    people = Enum.shuffle(collection.people)
    tasks = Enum.shuffle(collection.tasks)

    assignment =
      if length(tasks) > length(people) do
        people =
          people ++ Enum.map(1..(length(tasks) - length(people)), fn _ -> Enum.random(people) end)

        Enum.zip(people, tasks) |> Enum.map(fn {p, t} -> %{"#{p.id}" => [t.id]} end)
      else
        Enum.zip(people, tasks) |> Enum.map(fn {p, t} -> %{"#{p.id}" => [t.id]} end)
      end

    assignment =
      Enum.reduce(assignment, fn x, acc -> Map.merge(acc, x, fn _k, v1, v2 -> v1 ++ v2 end) end)

    %{assignment: assignment, tasks: tasks, people: people, round: round + 1}
  end

  @doc """
  Returns an assignment pairing all people with all tasks.


  If they're more people than tasks only a subset of people
  get a task assigned.
  If they're more tasks than people the remaining tasks
  are unassigned.
  """
  def random_select_all_fit(collection) do
    round = get_current_round(collection)
    people = Enum.shuffle(collection.people)
    tasks = Enum.shuffle(collection.tasks)
    assignment = Enum.zip(people, tasks) |> Enum.map(fn {p, t} -> %{"#{p.id}" => [t.id]} end)
    assignment = Enum.reduce(assignment, &Map.merge/2)
    %{assignment: assignment, tasks: tasks, people: people, round: round + 1}
  end

  @doc """
  Return the last round set within the matches.
  """
  def get_current_round(collection) do
    matches = Matches.list_collection_matches(collection)
    Enum.max_by(matches, fn m -> m.round end, fn -> %{round: 0} end).round
  end
end
