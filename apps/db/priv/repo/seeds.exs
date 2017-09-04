defmodule DB.Seed do
  def seed do
    user = create_user()

    game = create_game(user.id)
    create_player(user.id, game.id)

    0..number_of_inserts()
    |> Task.async_stream(fn(_) ->
        fr = create_friend_request(user.id)
        create_player(fr.requested_user_id, game.id)
      end, [max_concurrency: 10])
    |> Stream.run

    # credo:disable-for-next-line
    IO.inspect "Data Seeded for-- username: #{user.username}/id: #{user.id}"
  end

  defp create_user do
    {:ok, user} = DB.User.create(%{
      username: FakerElixir.Helper.unique!(:usernames, fn -> "#{FakerElixir.Internet.user_name}-#{rand_string()}" end),
      email: FakerElixir.Helper.unique!(:emails, fn -> "#{rand_string()}-#{FakerElixir.Internet.email}" end),
      password: FakerElixir.Internet.password(:strong)
    })

    # credo:disable-for-next-line
    IO.inspect "Created User-- #{user.username}/#{user.id}"

    user
  end

  defp create_friend_request(requesting_user_id \\ nil, requested_user_id \\ nil) do
    {:ok, fr} = DB.FriendRequest.create(
      requesting_user_id || create_user().id,
      requested_user_id || create_user().id,
      FakerElixir.Helper.pick(~w(pending accepted))
      )

    # credo:disable-for-next-line
    IO.inspect "Created Friend Request-- #{fr.id}"

    fr
  end

  defp create_player(user_id \\ nil, game_id \\ nil) do
    {:ok, player} = DB.Player.create(%{
      status: FakerElixir.Helper.pick(~w(user-pending active)),
      user_id: user_id || create_user().id,
      game_id: game_id || create_game().id,
    })

    # credo:disable-for-next-line
    IO.inspect "Created Player-- #{player.id}"

    player
  end

  defp create_game(user_id \\ nil) do
    {:ok, game} = DB.Game.create(%{
      status: FakerElixir.Helper.pick(~w(pending active complete)),
      title: FakerElixir.Lorem.words,
      owner_id: user_id || create_user().id,
      round_length: FakerElixir.Number.between(5..50)
    })

    # credo:disable-for-next-line
    IO.inspect "Created Game-- #{game.id}"

    game
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

    String.to_integer(first_arg || "10")
  end
end

DB.Seed.seed()
