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

  #### dependent matches

  Toggle if a future match is dependent on prior matches.
  For example a person matched in a prior match is only added
  back to the urn if all people are matched and a "new round"
  is started.

  ### `:random_all`

  Assigns all tasks randomly to all persons. If they're
  more tasks then people some of them get multiple tasks.

  ### `:random_all_fit`

  Assigns all tasks randomly to all persons. If they're
  more tasks then people the tasks are not assigned.
  """
  def match_tasks(collection) do
    collection = Repo.preload(collection, [:people, :tasks])

    if length(collection.tasks) < 1 or length(collection.people) < 1 do
      {:error, "Not enough tasks or people"}
    else
      assignment =
        case collection.algorithm do
          :random_one ->
            random_select_one(collection)

          :random_all_fit ->
            random_select_all_fit(collection)

          :random_all ->
            random_select_all(collection)

          _ ->
            {:error, "Algorithm unknown"}
        end

      {:ok, assignment}
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
    # Get all previous matches
    matches = Matches.list_collection_matches(collection)
    round = get_current_round(matches)

    {tasks, people} =
      if collection.put_back or length(matches) < 1 do
        {collection.tasks, collection.people}
      else
        random_select_one(collection, matches)
      end

    task_pos = 0..(length(tasks) - 1) |> Enum.random()
    task = Enum.at(tasks, task_pos)
    person_pos = 0..(length(people) - 1) |> Enum.random()
    person = Enum.at(people, person_pos)

    round =
      if length(tasks) != length(collection.tasks) or length(tasks) != length(collection.tasks) do
        round
      else
        # Increase the round if the stored and used tasks or people are equal
        round + 1
      end

    %{
      assignment: %{person.id => [task.id]},
      tasks: [task],
      people: [person],
      round: round
    }
  end

  @doc """
  Return a tuple of tasks and people.

  This handles the case where `put_back` is set to true.
  It filters all tasks or people from the current round out of
  the original collection tasks or people. All remaining tasks and people
  are returned for the next matching round.

  NOTE: If the tasks or people are unequal and for example all people are already
  matched but some tasks are left, then all people are taken into account for the
  matching until all tasks are matched and the next round is started.
  """
  def random_select_one(collection, matches) do
    # Get all people and tasks from the current matching round
    max_round = get_current_round(matches)

    current_round_people =
      matches |> Enum.filter(fn m -> m.round == max_round end) |> Enum.flat_map(& &1.people)

    current_round_tasks =
      matches |> Enum.filter(fn m -> m.round == max_round end) |> Enum.flat_map(& &1.tasks)

    # Filter all people and tasks which are unmatched in the current round
    people = collection.people |> Enum.filter(fn p -> p not in current_round_people end)
    tasks = collection.tasks |> Enum.filter(fn p -> p not in current_round_tasks end)
    # If all tasks or people are already matched in the current round return the original list
    people =
      if length(people) == 0 do
        collection.people
      else
        people
      end

    tasks =
      if length(tasks) == 0 do
        collection.tasks
      else
        tasks
      end

    {tasks, people}
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

    people =
      if length(tasks) > length(people) do
        people ++ Enum.map(1..(length(tasks) - length(people)), fn _ -> Enum.random(people) end)
      else
        people
      end

    assignment = Enum.zip(people, tasks) |> Enum.map(fn {p, t} -> %{"#{p.id}" => [t.id]} end)

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
  def get_current_round(matches) do
    Enum.max_by(matches, fn m -> m.round end, fn -> %{round: 0} end).round
  end
end
