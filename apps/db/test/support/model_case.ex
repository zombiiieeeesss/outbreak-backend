defmodule DB.ModelCase do
  @moduledoc """
  This module defines the test case to be used by
  model tests.

  You may define functions here to be used as helpers in
  your model tests. See `errors_on/2`'s definition as reference.

  Finally, if the test case interacts with the database,
  it cannot be async. For this reason, every test runs
  inside a transaction which is reset at the beginning
  of the test unless the test case is marked as async.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      alias DB.Repo

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      import DB.ModelCase
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(DB.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(DB.Repo, {:shared, self()})
    end

    :ok
  end

  def user_params do
    %{username: UUID.uuid4(), password: "123123123", email: "#{UUID.uuid4()}@"}
  end

  @doc """
  Creates a random user.
  """
  def create_user do
    %DB.User{} |> DB.User.registration_changeset(user_params()) |> DB.Repo.insert!
  end

  @doc """
  Creates a game with random users.
  """
  def create_game(user_1 \\ create_user(), user_2 \\ create_user()) do
    DB.create_game(user_1, user_2)
  end

  @doc """
  Adds a new stone to a game board.
  """
  def add_stone(game \\ create_game()) do
    [user|_] = DB.Repo.preload(game, :users).users

    params = %{
      "x_position" => Enum.random(1..9),
      "y_position" => Enum.random(1..9),
      "user_id" => user.id
    }
    DB.add_stone(game, params)
  end
end