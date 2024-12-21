# Elixir Rotation

This small web application allows to insert tasks and people into collections
and match them using one of three algorithms. The matching can be either started
manually or through a cron-like job. After a match a webhook is called with the result.

Matching algorithms:
* Random choice with all tasks and participants are used again
* Random choice with only remaining participants
* Random choice with only remaining tasks and participants

## Usage

To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
