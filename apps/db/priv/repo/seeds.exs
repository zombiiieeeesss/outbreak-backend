defmodule DB.Seed do
  def create_users do
    0..number_of_inserts()
    |> Task.async_stream(fn(_) -> create_user() end, [max_concurrency: 10])
    |> Stream.run
  end

  defp create_user do
    {:ok, user} = DB.User.create(%{
      username: FakerElixir.Name.name,
      email: FakerElixir.Internet.email,
      password: FakerElixir.Internet.password(:strong)
    })

    # credo:disable-for-next-line
    IO.inspect "Created User-- #{user.username}/#{user.id}"
  end

  defp number_of_inserts do
    first_arg =
      System.argv
      |> List.first

    String.to_integer(first_arg || "20")
  end
end

DB.Seed.create_users()
