defmodule API.Web.PlayerControllerTest do
  use API.Web.ConnCase

  @base_url "/v1/players"

  setup do
    user = create_user()
    game = create_game(%{owner_id: user.id})
    {:ok, token, _full_claims} = Guardian.encode_and_sign(user)

    user_ids = Enum.map(0..5, fn(_) -> create_user().id end)

    {:ok, %{user_ids: user_ids, user: user, game: game, token: token}}
  end

  describe "#create" do
    test "with valid params", %{conn: conn, game: game, user_ids: user_ids, token: token} do
      res =
        conn
        |> put_req_header("authorization", token)
        |> post(@base_url, %{game_id: game.id, user_ids: user_ids})

      assert res.status == 201

      body = json_response(res)

      Enum.each(body, fn(player) ->
        assert player.id
        assert Enum.member?(user_ids, player.user.id)
        assert player.game_id == game.id
        assert player.status == "user-pending"
      end)
    end

    test "when the user does not own the game", %{conn: conn, user_ids: user_ids, token: token} do
      game = create_game()

      res =
        conn
        |> put_req_header("authorization", token)
        |> post(@base_url, %{game_id: game.id, user_ids: user_ids})

      assert res.status == 401
    end

    test "with invalid auth credentials", %{conn: conn} do
      res = post(conn, @base_url, %{})
      assert res.status == 401
    end
  end

  describe "#update" do
    test "with valid params", %{conn: conn, token: token} do
      player = create_player()

      res =
        conn
        |> put_req_header("authorization", token)
        |> patch("#{@base_url}/#{player.id}", %{player: %{stats: %{distance: 100}}})

      assert res.status == 200

      body = json_response(res)
      assert body.stats.distance == 100

      player = DB.Repo.get(DB.Player, player.id)
      assert player.stats.distance == 100
    end
  end

  describe "#delete" do
    setup context do
      {:ok, player} = API.Player.create(context.user.id, context.game.id)

      {:ok, %{player: player}}
    end

    test "with valid Player id returns No Content",
      %{conn: conn, player: player, token: token} do
        url = "#{@base_url}/#{player.id}"
        res =
          conn
          |> put_req_header("authorization", token)
          |> delete(url)

        assert res.status == 204
    end

    test "with invalid Player id returns Not Found",
      %{conn: conn, token: token} do
        url = "#{@base_url}/123"
        res =
          conn
          |> put_req_header("authorization", token)
          |> delete(url)

        assert res.status == 404
    end
  end
end
