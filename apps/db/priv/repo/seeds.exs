defmodule DB.Seed do
  def create_users do
    0..number_of_inserts()
    |> Task.async_stream(fn(_) -> create_user() end, [max_concurrency: 10])
    |> Stream.run
  end

  defp create_user do
    {:ok, user} = DB.User.create(%{
      username: FakerElixir.Helper.unique!(:usernames, fn -> "#{FakerElixir.Internet.user_name}-#{rand_string()}" end),
      email: FakerElixir.Helper.unique!(:emails, fn -> "#{rand_string()}-#{FakerElixir.Internet.email}" end),
      password: FakerElixir.Internet.password(:strong)
    })

    # credo:disable-for-next-line
    IO.inspect "Created User-- #{user.username}/#{user.id}"
  end

  defp rand_string do
    5
    |> :crypto.strong_rand_bytes
    |> Base.encode64
    |> binary_part(0, 5)
  end

  defp number_of_inserts do
    first_arg =
      System.argv
      |> List.first

    String.to_integer(first_arg || "20")
  end
end

DB.Seed.create_users()
